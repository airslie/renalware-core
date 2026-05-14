# frozen_string_literal: true

module Renalware
  module UKRDC
    class RenalRegistryId
      pattr_initialize [:patient!]

      def to_s
        return "" if patient.renal_registry_id.blank?

        [
          Renalware.config.ukrdc_sending_facility_name,
          patient.renal_registry_id
        ].join("_")
      end
    end
  end
end
