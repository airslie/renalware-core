module Renalware
  module Transplants
    class DonorWorkupsController < BaseController
      load_and_authorize_resource class: Renalware::Transplants::DonorWorkup
      before_filter :load_patient

      def show
        @workup = DonorWorkup.for_patient(@patient)
        redirect_to edit_patient_transplants_donor_workup_path(@patient) if @workup.new_record?
      end

      def edit
        @workup = DonorWorkup.for_patient(@patient)
      end

      def update
        @workup = DonorWorkup.for_patient(@patient)

        if @workup.update_attributes workup_params
          redirect_to patient_transplants_donor_workup_path(@patient)
        else
          render :edit
        end
      end

      protected

      def workup_params
        params.require(:transplants_donor_workup).permit!
      end
    end
  end
end
