require 'test_helper'

class GroomersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:groomers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_groomer
    assert_difference('Groomer.count') do
      post :create, :groomer => { }
    end

    assert_redirected_to groomer_path(assigns(:groomer))
  end

  def test_should_show_groomer
    get :show, :id => groomers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => groomers(:one).id
    assert_response :success
  end

  def test_should_update_groomer
    put :update, :id => groomers(:one).id, :groomer => { }
    assert_redirected_to groomer_path(assigns(:groomer))
  end

  def test_should_destroy_groomer
    assert_difference('Groomer.count', -1) do
      delete :destroy, :id => groomers(:one).id
    end

    assert_redirected_to groomers_path
  end
end
