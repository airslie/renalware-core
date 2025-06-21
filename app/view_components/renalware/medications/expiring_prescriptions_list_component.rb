module Renalware
  module Medications
    class ExpiringPrescriptionsListComponent < ApplicationComponent
      include PresenterHelper
      include ApplicationHelper

      pattr_initialize [:current_user!]

      def expiring_hd_prescriptions
        @expiring_hd_prescriptions ||=
          ExpiringHDPrescriptionsForConsultantQuery.call(user: current_user)
      end

      def render?
        return false unless enabled?

        policy = PrescriptionBatchRenewalPolicy.new(current_user, nil)
        policy.index? && current_user.consultant?
      end

      def termination_date_is_in_the_past?(prescription)
        return false if prescription.termination&.terminated_on.blank?

        prescription.termination.terminated_on < Date.current
      end

      def terminated_ago_in_words(prescription)
        terminated_on = prescription.termination&.terminated_on
        return if terminated_on.blank?

        if terminated_on >= Date.current
          "in #{time_ago_in_words(terminated_on)}"
        else
          "#{time_ago_in_words(terminated_on)} ago"
        end
      end

      private

      def enabled? = Renalware.config.enable_expiring_prescriptions_list_component
    end
  end
end
