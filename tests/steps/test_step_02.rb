require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Adding session support
#
class TestStep02 < Test::Unit::TestCase
  class MyApp < Sinatra::Base
    enable :sessions

    get "/set1" do
      session[:hello] = "WIN!!"
      "Setting session"
    end

    get "/set2" do
      session[:hello] = "WIN AGAIN!!"
      "Setting session"
    end

    get "/get" do
      "Session: #{session[:hello]}"
    end
  end

  def test_using_sessions
    visit("/set1")
    visit("/get")
    assert_body "Session: WIN!!"
    
    visit("/set2")
    visit("/get")
    assert_body "Session: WIN AGAIN!!"
  end

end