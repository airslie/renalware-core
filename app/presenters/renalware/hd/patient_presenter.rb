require "renalware/hd"

module Renalware
  module HD
    class PatientPresenter < SimpleDelegator
      # delegate_missing_to :patient # TODO: when rails 5.1, try instead of SimpleDelegator
      delegate :document, to: :hd_profile
      delegate :transport, to: :document
      delegate :has_transport, to: :transport, prefix: false
      delegate :type, to: :transport, prefix: true

      def initialize(patient)
        patient = patient.__cgetobj__ if patient.respond_to?(:__getobj__)
        super(HD.cast_patient(patient))
      end

      private

      def hd_profile
        @hd_profile ||= __getobj__.hd_profile || NullObject.instance
      end
    end
  end
end
