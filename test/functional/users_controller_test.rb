#

require "#{File.dirname(__FILE__)}/../test_helper"

class UsersControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_without_user
    get :index
    assert_redirected_to :action => "login"
    assert_equal "Please log in", flash[:notice]
  end

  def test_index_with_user
    get :index, {}, { :user => users(:one).id }
    assert_response :success
    assert_template "index"
  end

  def test_login
    user = users(:one)
    post :login, :name => one.username, :password => 'secret'
    assert_redirected_to :action => "index'
    assert_equal one.id, session[:user]
  end


  def test_bad_password
    user = users(:one)
    post :login, :name => user.username, :password => 'wrong'
    assert_template "login"
  end




  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user
    assert_difference('User.count') do
      post :create, :user => { }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_show_user
    puts "********************>? " + users(:one).to_s

    get :show, :id => users(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => users(:one).id
    assert_response :success
  end

  def test_should_update_user
    put :update, :id => users(:one).id, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_destroy_user
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end

    assert_redirected_to users_path
  end
end
