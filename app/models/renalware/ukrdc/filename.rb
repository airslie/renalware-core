# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    # Formats a UKRDC patient XML filename
    class Filename
      pattr_initialize [:patient!, :batch_number!]

      def to_s
        patient_identifier = patient.nhs_number ||
                             patient.hospital_identifier&.id ||
                             patient.ukrdc_external_id

        if patient_identifier.blank?
          raise(ArgumentError, "Patient has no NHS number, local patient id or ukrdc external id")
        end

        site_code = Renalware.config.ukrdc_site_code # e.g. RJZ
        "#{site_code}_#{batch_number}_#{patient_identifier.upcase}.xml"
      end
    end
  end
end
