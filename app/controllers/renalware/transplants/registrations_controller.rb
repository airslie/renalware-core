require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class RegistrationsController < BaseController
      before_action :load_patient

      def show
        if registration.new_record?
          redirect_to edit_patient_transplants_registration_path(patient)
        else
          render locals: { patient: patient, registration: registration }
        end
      end

      def edit
        render locals: { patient: patient, registration: registration }
      end

      def update
        if update_registration
          redirect_to patient_transplants_recipient_dashboard_path(patient),
            notice: t(".success", model_name: "registration")
        else
          flash[:error] = t(".failed", model_name: "registration")
          render :edit, locals: { patient: patient, registration: registration }
        end
      end

      protected

      def update_registration
        registration.attributes = registration_params
        registration.statuses.first.by = current_user if registration.new_record?
        registration.save
      end

      def registration
        @registration ||= Registration.for_patient(@patient).first_or_initialize
      end

      def registration_params
        params
          .require(:transplants_registration)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :referred_on, :assessed_on, :entered_on, :contact, :notes,
          statuses_attributes: [:started_on, :description_id],
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_registration)
          .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
