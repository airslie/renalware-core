# frozen_string_literal: true

require_dependency "renalware/patients"
require "attr_extras"

module Renalware
  module Patients
    class ClearPatientUKRDCData
      pattr_initialize [:patient!, :by!]

      def self.call(**args)
        new(**args).call
      end

      def call
        patient.send_to_rpv = false
        patient.rpv_decision_on = Time.zone.today
        patient.rpv_recorded_by = by.to_s
        patient.save_by!(by)
      end
    end
  end
end
