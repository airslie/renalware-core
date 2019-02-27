# frozen_string_literal: true

require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonationsController < BaseController
      def show
        donation = Donation.for_patient(patient).find(params[:id])
        authorize donation
        render locals: { patient: patient, donation: donation }
      end

      def new
        donation = Donation.new
        authorize donation
        render locals: { patient: patient, donation: donation }
      end

      def create
        donation = Donation.new(patient: patient)
        donation.attributes = donation_params
        authorize donation

        if donation.save
          redirect_to patient_transplants_donor_dashboard_path(patient),
                      notice: success_msg_for("donation")
        else
          flash.now[:error] = failed_msg_for("donation")
          render :new, locals: { patient: patient, donation: donation }
        end
      end

      def edit
        donation = Donation.for_patient(patient).find(params[:id])
        authorize donation
        render locals: { patient: patient, donation: donation }
      end

      def update
        donation = Donation.for_patient(patient).find(params[:id])
        donation.attributes = donation_params
        authorize donation

        if donation.save
          redirect_to patient_transplants_donor_dashboard_path(patient),
                      notice: success_msg_for("donation")
        else
          flash.now[:error] = failed_msg_for("donation")
          render :edit, locals: { patient: patient, donation: donation }
        end
      end

      private

      def donation_params
        params.require(:transplants_donation).permit(attributes)
      end

      def attributes
        [
          :state,
          :recipient_id,
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
