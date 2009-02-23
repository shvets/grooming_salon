require 'test_helper'

class BreedsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:breeds)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_breed
    assert_difference('Breed.count') do
      post :create, :breed => { }
    end

    assert_redirected_to breed_path(assigns(:breed))
  end

  def test_should_show_breed
    get :show, :id => breeds(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => breeds(:one).id
    assert_response :success
  end

  def test_should_update_breed
    put :update, :id => breeds(:one).id, :breed => { }
    assert_redirected_to breed_path(assigns(:breed))
  end

  def test_should_destroy_breed
    assert_difference('Breed.count', -1) do
      delete :destroy, :id => breeds(:one).id
    end

    assert_redirected_to breeds_path
  end
end
