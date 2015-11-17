module Renalware
  module Transplants
    class DonationsController < BaseController
      before_filter :load_patient

      def show
        @donation = Donation.for_patient(@patient).first_or_initialize
        authorize @donation

        redirect_to edit_patient_transplants_donation_path(@patient) if @donation.new_record?
      end

      def edit
        @donation = Donation.for_patient(@patient).first_or_initialize
        authorize @donation
      end

      def update
        @donation = Donation.for_patient(@patient).first_or_initialize
        authorize @donation

        if @donation.update_attributes(donation_params)
          redirect_to patient_transplants_donation_path(@patient)
        else
          render :edit
        end
      end

      private

      def donation_params
        params.require(:transplants_donation)
          .permit(attributes)
          # .merge(document: document_attributes)
      end

      def attributes
        [
          :status, :notes
        ]
      end

      def document_attributes
        params.require(:transplants_donation)
         .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
