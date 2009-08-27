require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Inline template rendering
#
class TestStep06 < Test::Unit::TestCase
  class MyApp < Sinatra::Base
    get "/hello" do
      @world = "world"
      erb "Hello: <%= @world %>"
    end
  end

  def test_using_before_callbacks
    visit("/hello")
    assert_body "Hello: world"
  end

end