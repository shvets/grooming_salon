require "#{File.dirname(__FILE__)}/../test_helper"

class HomeControllerTest < ActionController::TestCase
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

end
