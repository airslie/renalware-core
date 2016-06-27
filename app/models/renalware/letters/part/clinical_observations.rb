require "renalware/letters/part"

module Renalware
  module Letters
    class Part::ClinicalObservations < Part
      delegate :height, :weight, :bp, :bmi, :urine_blood, :urine_protein, to: :event

      def to_partial_path
        "renalware/letters/parts/clinical_observations"
      end
    end
  end
end
