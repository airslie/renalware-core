# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    # If the optional :changed_since argument is passed we select all RPV
    # patients how have been updated since that date. Otherwise we select all RPV
    # patients who have changed since the last time they were exported.
    class PatientsQuery
      def call(changed_since: nil)

        if changed_since.present?
          rpv_patients.where("updated_at > ?", changed_since)
        else
          rpv_patients.where("(sent_to_ukrdc_at is null) or (updated_at > sent_to_ukrdc_at)")
        end
      end

      private

      def rpv_patients
        Renalware::Patient.where(send_to_rpv: true)
      end
    end
  end
end
