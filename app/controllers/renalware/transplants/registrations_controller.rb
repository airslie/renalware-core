module Renalware
  module Transplants
    class RegistrationsController < BaseController
      before_filter :load_patient

      def show
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration
        redirect_to edit_patient_transplants_registration_path(@patient) if @registration.new_record?
      end

      def edit
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration
      end

      def update
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration

        if @registration.update_attributes(registration_params)
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end

      protected

      def registration_params
        document_attributes = params.require(:transplants_registration)
          .fetch(:document, nil).try(:permit!)
        params.require(:transplants_registration).permit.merge(document: document_attributes)
      end
    end
  end
end
