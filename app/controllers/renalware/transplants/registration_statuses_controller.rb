module Renalware
  module Transplants
    class RegistrationStatusesController < BaseController
      before_filter :load_patient

      def create
        @registration = Registration.for_patient(@patient).first_or_initialize
        authorize @registration

        if @status = @registration.add_status!(status_params)
          redirect_to patient_transplants_dashboard_path(@patient)
        else
          render :edit
        end
      end


      # def edit
      #   @registration = Registration.for_patient(@patient).first_or_initialize
      #   authorize @registration
      # end

      # def update
      #   @registration = Registration.for_patient(@patient).first_or_initialize
      #   authorize @registration

      #   if @registration.update_attributes(registration_params)
      #     redirect_to patient_transplants_dashboard_path(@patient)
      #   else
      #     render :edit
      #   end
      # end

      def destroy
        registration = Registration.for_patient(@patient).first_or_initialize
        registration.statuses.find(params[:id]).destroy

        redirect_to patient_transplants_dashboard_path(@patient)
      end

      protected

      def status_params
        statuses_attributes = [:started_on, :description_id]
        params.require(:transplants_registration_status).permit(statuses_attributes)
      end
    end
  end
end
