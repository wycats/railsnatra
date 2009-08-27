$:.unshift File.join(File.dirname(__FILE__), '..')
require "rubygems"
require "sinatrails"
require "webrat"
require "rack/test"
require "test/unit"
# require "active_support/test_case"

Webrat.configure do |config|
  config.mode = :rack
end

class Test::Unit::TestCase
  include Webrat::Methods
  include Rack::Test::Methods

  def app
    @app ||= self.class.const_get(:MyApp).to_app
  end

  def assert_body(body)
    assert_equal body, last_response.body
  end

  def assert_missing
    assert_equal 404, last_response.status
  end
end