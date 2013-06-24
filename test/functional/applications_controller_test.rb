require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  setup do
    @application = applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create application" do
    assert_difference('Application.count') do
      post :create, application: { application_number: @application.application_number, biology: @application.biology, birth_date: @application.birth_date, chemistry: @application.chemistry, document_date: @application.document_date, document_date: @application.document_date, document_number: @application.document_number, document_series: @application.document_series, document_series: @application.document_series, edu_document_number: @application.edu_document_number, edu_document_type_id: @application.edu_document_type_id, entrant_first_name: @application.entrant_first_name, entrant_last_name: @application.entrant_last_name, entrant_middle_name: @application.entrant_middle_name, gender_id: @application.gender_id, identity_document_type_id: @application.identity_document_type_id, last_dany_day: @application.last_dany_day, lech_budget: @application.lech_budget, lech_paid: @application.lech_paid, nationality_type_id: @application.nationality_type_id, need_hostel: @application.need_hostel, original_received: @application.original_received, ped_budget: @application.ped_budget, ped_paid: @application.ped_paid, registration_date: @application.registration_date, russian: @application.russian, status_id: @application.status_id, stomat_budget: @application.stomat_budget, stomat_paid: @application.stomat_paid, target_organization_id: @application.target_organization_id }
    end

    assert_redirected_to application_path(assigns(:application))
  end

  test "should show application" do
    get :show, id: @application
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @application
    assert_response :success
  end

  test "should update application" do
    put :update, id: @application, application: { application_number: @application.application_number, biology: @application.biology, birth_date: @application.birth_date, chemistry: @application.chemistry, document_date: @application.document_date, document_date: @application.document_date, document_number: @application.document_number, document_series: @application.document_series, document_series: @application.document_series, edu_document_number: @application.edu_document_number, edu_document_type_id: @application.edu_document_type_id, entrant_first_name: @application.entrant_first_name, entrant_last_name: @application.entrant_last_name, entrant_middle_name: @application.entrant_middle_name, gender_id: @application.gender_id, identity_document_type_id: @application.identity_document_type_id, last_dany_day: @application.last_dany_day, lech_budget: @application.lech_budget, lech_paid: @application.lech_paid, nationality_type_id: @application.nationality_type_id, need_hostel: @application.need_hostel, original_received: @application.original_received, ped_budget: @application.ped_budget, ped_paid: @application.ped_paid, registration_date: @application.registration_date, russian: @application.russian, status_id: @application.status_id, stomat_budget: @application.stomat_budget, stomat_paid: @application.stomat_paid, target_organization_id: @application.target_organization_id }
    assert_redirected_to application_path(assigns(:application))
  end

  test "should destroy application" do
    assert_difference('Application.count', -1) do
      delete :destroy, id: @application
    end

    assert_redirected_to applications_path
  end
end
