module Renalware
  module Transplants
    class RegistrationStatusesController < BaseController
      before_filter :load_patient
      before_filter :load_registration

      def create
        @status = @registration.add_status!(status_params)

        respond_to do |format|
          format.html { redirect_to patient_transplants_dashboard_path(@patient) }
          format.js
        end
      end

      def edit
        @status = @registration.statuses.find(params[:id])
      end

      def update
        existing_status = @registration.statuses.find(params[:id])
        @status = @registration.update_status!(existing_status, status_params)

        if @status.valid?
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end

      def destroy
        status = @registration.statuses.find(params[:id])
        @registration.delete_status!(status)

        redirect_to patient_transplants_dashboard_path(@patient)
      end

      protected

      def load_registration
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration
      end

      def status_params
        params.require(:transplants_registration_status).permit(:started_on, :description_id)
      end
    end
  end
end
