require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

# Adding simple callbacks
#
class TestStep03 < Test::Unit::TestCase
  class MyApp < Sinatra::Base

    before do
      @what = "awesome!!!"
    end

    get "/hooked" do
      "This is: #{@what}"
    end
  end

  def test_using_before_callbacks
    visit("/hooked")
    assert_body "This is: awesome!!!"
  end

end