module Renalware
  class BaseController < ActionController::Base
    include Concerns::DeviseControllerMethods
    include Pundit

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    layout "renalware/layouts/application"

    before_filter :prepare_patient_search

    private

    def prepare_patient_search
      @patient_search = Renalware::Patient.search(params[:q])
      @patient_search.sorts = ["family_name", "given_name"]
    end

    def load_patient(patient_id = params[:patient_id])
      @patient = Renalware::Patient.find(patient_id)

      authorize @patient
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to patients_path
    end
  end
end
