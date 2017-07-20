require "renalware/hd"

module Renalware
  module HD
    class PatientPresenter < SimpleDelegator
      # delegate_missing_to :patient # TODO: when rails 5.1, try instead of SimpleDelegator
      delegate :document, to: :hd_profile
      delegate :hospital_unit, to: :hd_profile, allow_nil: true
      delegate :unit_code, to: :hospital_unit, allow_nil: true, prefix: true
      delegate :transport, to: :document
      delegate :has_transport, to: :transport, prefix: false
      delegate :type, to: :transport, prefix: true
      alias_method :dialysing_at_unit, :hospital_unit_unit_code

      def initialize(patient)
        patient = patient.__getobj__ if patient.respond_to?(:__getobj__)
        super(HD.cast_patient(patient))
      end

      private

      def hd_profile
        @hd_profile ||= __getobj__.hd_profile || NullObject.instance
      end
    end
  end
end
