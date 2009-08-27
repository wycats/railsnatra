require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Getting a very basic Sinatra::Base working
#
class TestStep01 < Test::Unit::TestCase
  class MyApp < Sinatra::Base
    get "/hello" do
      "HELLO World"
    end

    post "/world" do
      "Hello from POST"
    end
  end

  def test_successful_get
    visit("/hello")
    assert_body "HELLO World"
  end

  def test_successful_post
    visit("/world", :post)
    assert_body "Hello from POST"
  end

  def test_missing_route
    visit("/fail")
    assert_missing
  end

end