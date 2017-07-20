module Renalware
  module Transplants
    class PatientPresenter < SimpleDelegator

      def initialize(patient)
        super(Transplants.cast_patient(patient.__getobj__))
      end

      def current_registration_status
        @current_registration_status ||= begin
          Transplants::Registration.for_patient(__getobj__).first&.current_status
        end
      end
    end
  end
end
