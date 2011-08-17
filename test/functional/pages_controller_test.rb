require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  render_views
  
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end
  
test "should get other" do
    get other
    assert_response :success
  end

end
