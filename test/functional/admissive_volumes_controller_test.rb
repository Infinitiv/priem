require 'test_helper'

class AdmissiveVolumesControllerTest < ActionController::TestCase
  setup do
    @admissive_volume = admissive_volumes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admissive_volumes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admissive_volume" do
    assert_difference('AdmissiveVolume.count') do
      post :create, admissive_volume: {  }
    end

    assert_redirected_to admissive_volume_path(assigns(:admissive_volume))
  end

  test "should show admissive_volume" do
    get :show, id: @admissive_volume
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admissive_volume
    assert_response :success
  end

  test "should update admissive_volume" do
    put :update, id: @admissive_volume, admissive_volume: {  }
    assert_redirected_to admissive_volume_path(assigns(:admissive_volume))
  end

  test "should destroy admissive_volume" do
    assert_difference('AdmissiveVolume.count', -1) do
      delete :destroy, id: @admissive_volume
    end

    assert_redirected_to admissive_volumes_path
  end
end
