require "digest/sha2"
require "action_dispatch"
require "action_controller"
require "usher"

module Sinatra
  class Base < ActionController::Metal
    class << self
      # Returns a valid rack application for the
      # current sinatra application declaration.
      def to_app
        lambda { |env| [200, {}, "Placeholder!"] }
      end

      def get(*)
        # Not implemented...
      end

      def post(*)
        # Not implemented...
      end
    end
  end
end