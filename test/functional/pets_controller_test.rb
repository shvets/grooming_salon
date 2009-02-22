require 'test_helper'

class PetsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pet
    assert_difference('Pet.count') do
      post :create, :pet => { }
    end

    assert_redirected_to pet_path(assigns(:pet))
  end

  def test_should_show_pet
    get :show, :id => pets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pets(:one).id
    assert_response :success
  end

  def test_should_update_pet
    put :update, :id => pets(:one).id, :pet => { }
    assert_redirected_to pet_path(assigns(:pet))
  end

  def test_should_destroy_pet
    assert_difference('Pet.count', -1) do
      delete :destroy, :id => pets(:one).id
    end

    assert_redirected_to pets_path
  end
end
