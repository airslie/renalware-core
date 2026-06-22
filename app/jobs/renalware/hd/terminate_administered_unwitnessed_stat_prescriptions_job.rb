module Renalware
  module HD
    # Periodically (probably overnight) this job finds one-dose HD prescriptions that have been
    # administered but not automatically terminated. This is mainly for legacy stat prescriptions
    # that were recorded before give-once behaviour moved to fixed_number_of_doses = 1.
    class TerminateAdministeredUnwitnessedStatPrescriptionsJob < ApplicationJob
      def perform
        # Note the recorded_on condition is to prevent the circumstance where we might keep on
        # selecting the same rows each night but not updating all - and after eg a year
        # the un-updated set could become cumbersome and
        administrations = PrescriptionAdministration
          .having_given_but_unwitnessed_prescriptions
          .where("recorded_on > ?", 6.months.ago)

        administrations.find_in_batches do |batch|
          batch.each do |administration|
            # paranoia.., SQL should have excluded terminated prescriptions
            next if administration.prescription.termination.present?

            administration.prescription.build_termination(
              terminated_on: Time.zone.now,
              by: SystemUser.find,
              notes: "One-dose HD prescription terminated automatically by background job: " \
                     "administered #{administration.recorded_on} but not witnessed."
            ).save!
          end
        end
      end
    end
  end
end
