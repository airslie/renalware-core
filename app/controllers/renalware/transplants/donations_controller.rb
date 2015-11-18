module Renalware
  module Transplants
    class DonationsController < BaseController
      before_filter :load_patient

      def show
        @donation = Donation.for_patient(@patient).find(params[:id])
      end

      def new
        @donation = Donation.new
      end

      def create
        @donation = Donation.new(patient: @patient)
        @donation.attributes = donation_params

        if @donation.save
          redirect_to patient_transplants_donor_dashboard_path(@patient)
        else
          render :new
        end
      end

      def edit
        @donation = Donation.for_patient(@patient).find(params[:id])
      end

      def update
        @donation = Donation.for_patient(@patient).find(params[:id])
        @donation.attributes = donation_params

        if @donation.save
          redirect_to patient_transplants_donor_dashboard_path(@patient)
        else
          render :edit
        end
      end

      private

      def donation_params
        params.require(:transplants_donation).permit(attributes)
      end

      def attributes
        [
          :state,
          :relationship_with_recipient,
          :relationship_with_recipient_other,
          :blood_group_compatibility,
          :mismatch_grade,
          :paired_pooled_donation,
          :volunteered_on,
          :first_seen_on,
          :workup_completed_on,
          :donated_on,
          :notes
        ]
      end
    end
  end
end
