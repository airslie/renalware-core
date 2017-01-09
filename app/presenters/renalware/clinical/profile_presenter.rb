require_dependency "renalware"

module Renalware
  module Clinical
    class ProfilePresenter
      attr_reader :patient

      def initialize(patient)
        @patient = Clinical.cast_patient(patient)
      end

      def allergies
        patient.allergies
      end

      def smoking_history
        patient.document.history.try!(:smoking)
      end

      def alcohol_history
        patient.document.history.try!(:alcohol)
      end
    end
  end
end
