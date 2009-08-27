require "digest/sha2"
require "action_dispatch"
require "action_controller"
require "usher"

module Sinatra
  class Base < ActionController::Metal
    include ActionController::RackConvenience

    class << self
      # Set @_routes on child classes
      def inherited(klass)
        klass.class_eval { @_routes = [] }
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
    end

    # The default behavior is that the action's return value
    # is the response body.
    def process_action(*)
      self.response_body = super
    end
  end
end