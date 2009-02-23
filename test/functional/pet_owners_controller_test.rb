require 'test_helper'

class PetOwnersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pet_owners)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pet_owner
    assert_difference('PetOwner.count') do
      post :create, :pet_owner => { }
    end

    assert_redirected_to pet_owner_path(assigns(:pet_owner))
  end

  def test_should_show_pet_owner
    get :show, :id => pet_owners(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pet_owners(:one).id
    assert_response :success
  end

  def test_should_update_pet_owner
    put :update, :id => pet_owners(:one).id, :pet_owner => { }
    assert_redirected_to pet_owner_path(assigns(:pet_owner))
  end

  def test_should_destroy_pet_owner
    assert_difference('PetOwner.count', -1) do
      delete :destroy, :id => pet_owners(:one).id
    end

    assert_redirected_to pet_owners_path
  end
end
