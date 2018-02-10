require_dependency "application_controller"

module Renalware
  class BaseController < ApplicationController
    include Concerns::DeviseControllerMethods
    include Pundit

    before_action :set_paper_trail_whodunnit
    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    # Expose a few attributes for use in the patient layout and its partials.
    # As a rule, we should be passing variables explicitly to all view using `locals`;
    # however, while not a fan of `helper_method`, exposing e.g. current_patient this (akin to
    # Devise's current_user) allows a layout to access e.g. the current patient easily,
    # and is more encapsulated and less bug-prone than accessing @patient directly
    helper_method :current_patient
    alias_attribute :current_patient, :patient

    def patient
      @patient ||= Renalware::Patient.find_by!(secure_id: params[:patient_id])
    end

    protected

    def patient_search
      Patients::PatientSearch.call(params)
    end

    def success_msg_for(model_name)
      t(".success", model_name: model_name)
    end

    def failed_msg_for(model_name)
      t(".failed", model_name: model_name)
    end

    def paginate(collection, default_per_page: 25)
      collection.page(params[:page]).per(params[:per_page] || default_per_page)
    end

    private

    # TODO: remove load_patient before_action once refactored out of other controllers.
    # Individual patient-level controllers can authorise using the PolicyPatient if they like,
    # but I believe it will be more extensible and intention revealing if authorisation is done
    # on the entity being actioned e.g. a Prescription. That way provides more authorisation
    # granularity if required, for example if it transpires deleting a Prescriptions is actually
    # possible if you have a certain role.
    def load_patient
      authorize patient
      patient
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to dashboard_path
    end
  end
end
