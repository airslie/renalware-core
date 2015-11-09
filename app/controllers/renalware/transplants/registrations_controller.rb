module Renalware
  module Transplants
    class RegistrationsController < BaseController
      before_filter :load_patient
      before_filter :load_registration

      def show
        url = edit_patient_transplants_registration_path(@patient)
        redirect_to url if @registration.new_record?
      end

      def edit
      end

      def update
        @registration.attributes = registration_params
        @registration.statuses.first.by = current_user if @registration.new_record?
        if @registration.save
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end

      protected

      def load_registration
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration
      end

      def registration_params
        attributes = [
          :referred_on, :assessed_on, :contact, :notes,
          statuses_attributes: [:started_on, :description_id],
          document: []
        ]
        document_attributes = params.require(:transplants_registration)
          .fetch(:document, nil).try(:permit!)
        params.require(:transplants_registration)
          .permit(attributes).merge(document: document_attributes)
      end
    end
  end
end
