require 'test_helper'

class VarsControllerTest < ActionController::TestCase
  setup do
    @var = vars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create var" do
    assert_difference('Var.count') do
      post :create, var: { name: @var.name, value: @var.value }
    end

    assert_redirected_to var_path(assigns(:var))
  end

  test "should show var" do
    get :show, id: @var
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @var
    assert_response :success
  end

  test "should update var" do
    put :update, id: @var, var: { name: @var.name, value: @var.value }
    assert_redirected_to var_path(assigns(:var))
  end

  test "should destroy var" do
    assert_difference('Var.count', -1) do
      delete :destroy, id: @var
    end

    assert_redirected_to vars_path
  end
end
