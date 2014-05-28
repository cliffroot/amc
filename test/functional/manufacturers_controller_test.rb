require 'test_helper'

class ManufacturersControllerTest < ActionController::TestCase
  setup do
    @manufacturer = manufacturers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manufacturer" do
    assert_difference('Manufacturer.count') do
      post :create, manufacturer: { column_amount: @manufacturer.column_amount, column_code: @manufacturer.column_code, column_description: @manufacturer.column_description, column_price: @manufacturer.column_price, column_weight: @manufacturer.column_weight, formula_del_eu: @manufacturer.formula_del_eu, formula_del_uae: @manufacturer.formula_del_uae, formula_price: @manufacturer.formula_price, name: @manufacturer.name }
    end

    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should show manufacturer" do
    get :show, id: @manufacturer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manufacturer
    assert_response :success
  end

  test "should update manufacturer" do
    put :update, id: @manufacturer, manufacturer: { column_amount: @manufacturer.column_amount, column_code: @manufacturer.column_code, column_description: @manufacturer.column_description, column_price: @manufacturer.column_price, column_weight: @manufacturer.column_weight, formula_del_eu: @manufacturer.formula_del_eu, formula_del_uae: @manufacturer.formula_del_uae, formula_price: @manufacturer.formula_price, name: @manufacturer.name }
    assert_redirected_to manufacturer_path(assigns(:manufacturer))
  end

  test "should destroy manufacturer" do
    assert_difference('Manufacturer.count', -1) do
      delete :destroy, id: @manufacturer
    end

    assert_redirected_to manufacturers_path
  end
end
