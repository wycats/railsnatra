require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Rendering templates
#
class TestStep05 < Test::Unit::TestCase
  class MyApp < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), "..", '..', "views")

    get "/hello" do
      erb :hello
    end
  end

  def test_using_before_callbacks
    visit("/hello")
    assert_body "Hello from template"
  end

end