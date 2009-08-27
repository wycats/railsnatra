require "digest/sha2"
require "action_dispatch"
require "action_controller"
require "usher"

module Sinatra
  class Base < ActionController::Metal
    include ActionController::RackConvenience
    include AbstractController::Callbacks
    include ActionController::RenderingController

    class << self
      # Set @_routes on child classes
      def inherited(klass)
        klass.class_eval { @_routes = [] }
      end

      # Sinatra uses the before keyword instead of
      # before_filter, so let's alias the two.
      alias before before_filter

      # A helper method that provides a nice API
      # for setting arbitrary settings
      def set(name, value)
        send("_set_#{name}", value)
      end

      # Nicer way of implementing the common set :foo, true
      # idiom.
      def enable(name)
        set(name, true)
      end

      # Returns a valid rack application for the
      # current sinatra application declaration.
      def to_app
        routes, controller = @_routes, self

        # We're using Usher as a router for this project. To
        # simplify things, we just used the rack interface to
        # router and it's DSL.
        app = Usher::Interface.for(:rack) do
          routes.each do |route|
            conditions = {:request_method => route[:method]}
            add(route[:uri], :conditions => conditions.merge(route[:options])).
              to(controller.action(route[:action]))
          end
        end

        if @_sessions
          # If we are using sessions, then wrap the application with the
          # session cookie store middleware.
          app = ActionDispatch::Session::CookieStore.new(app, {:key => "_secret_key",
            :secret => Digest::SHA2.hexdigest(Time.now.to_s + rand(100).to_s)})
        end

        app
      end

      def get(uri, options = {}, &block)
        route(:get,  uri, options, &block)
      end

      def post(uri, options = {}, &block)
        route(:post, uri, options, &block)
      end

    private

      def route(http_method, uri, options, &block)
        # Since we need unique actions for each possible GET,
        # POST, etc... URLs, we add the method in the action
        # name. ActionController::Metal has the ability to
        # route an action with any name format.
        action_name = "[#{http_method}] #{uri}"
        # We save the route options in the global @_routes
        # variable so that we can build the routes when the
        # app is generated.
        @_routes << {:method => http_method.to_s.upcase, :uri => uri,
                     :action => action_name, :options => options}
        # Now, we finally create the action method.
        define_method(action_name, &block)
      end

      # If we are setting the sessions, then include the
      # appropriate module.
      def _set_sessions(value)
        @_sessions = value
        include ActionController::Session if value
      end

      # Alias the method for settingup the views to
      # the append view path method
      alias _set_views append_view_path
    end

    # Halt can be implemented by simply throwing.
    def halt(body = "")
      throw(:halt, body)
    end

    # The default behavior is that the action's return value
    # is the response body.
    def process_action(*)
      # We are now catching the throw that could be sent
      # when halting from a before callback.
      self.response_body = catch(:halt) { super }
    end

    # Loop over the template render methods and define them
    %w(haml erb builder).each do |type|
      define_method(type) do |thing|
        return sinatra_render_inline(thing, type) if thing.is_a?(String)
        return sinatra_render_file(thing)
      end
    end

    # Simple proxy to our render API
    def sinatra_render_file(name)
      render :template => name.to_s
    end

    def sinatra_render_inline(string, type)
      render :inline => string, :type => type
    end
  end
end