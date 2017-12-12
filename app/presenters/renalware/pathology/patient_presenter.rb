require "renalware/hd"

module Renalware
  module Pathology
    class PatientPresenter < SimpleDelegator
      def initialize(patient)
        super(Pathology.cast_patient(patient.__getobj__))
      end
    end
  end
end
