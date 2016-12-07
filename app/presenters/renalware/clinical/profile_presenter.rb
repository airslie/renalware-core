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
    end
  end
end
