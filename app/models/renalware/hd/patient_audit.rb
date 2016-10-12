require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class PatientAudit
      attr_accessor :patient

      def initialize(patient)
        @patient = patient
      end

      def sessions
        @session ||= Session.for_patient(patient).limit(10).ordered
      end
    end
  end
end
