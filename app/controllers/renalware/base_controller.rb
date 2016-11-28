module Renalware
  class BaseController < ApplicationController
    include Concerns::DeviseControllerMethods
    include Pundit

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    layout "renalware/layouts/application"

    # Expose a few attributes for use in the patient layout and its partials.
    # As a rule, we should be passing variables explicitly to all view using `locals`;
    # however, while not a fan of `helper_method`, exposing e.g. current_patient this (akin to
    # Devise's current_user) allows a layout to access e.g. the current patient easily,
    # and is more encapsulated and less bug-prone than accessing @patient directly
    helper_method :current_patient

    protected

    def patient(patient_id: params[:patient_id])
      @patient ||= Renalware::Patient.find(patient_id)
    end
    alias_attribute :current_patient, :patient

    # Override ApplicationController, where this default `helper_method` is defined.
    def patient_search
      @patient_search ||= begin
        Renalware::Patient.search(params[:q]).tap do |search|
          search.sorts = %w(family_name given_name)
        end
      end
    end

    private

    # TODO: remove load_patient before_action once refactored out of other controllers.
    # Individual patient-level controllers can authorise using the PolicyPatient if they like,
    # but I believe it will be more extensible and intention revealing if authorisation is done
    # on the entity being actioned e.g. a Prescription. That way provides more authorisation
    # granularity if required, for example if it transpires deleting a Prescriptions is actually
    # possible if you have a certain role.
    def load_patient(patient_id = params[:patient_id])
      authorize patient(patient_id: patient_id)
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to patients_path
    end
  end
end
