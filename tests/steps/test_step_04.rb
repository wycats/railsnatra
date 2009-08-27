require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Halting from callbacks
#
class TestStep04 < Test::Unit::TestCase
  class MyApp < Sinatra::Base

    before do
      halt "WIN!"
    end

    get "/hooked" do
      "EPIC FAIL!"
    end
  end

  def test_using_before_callbacks
    visit("/hooked")
    assert_body "WIN!"
  end

end