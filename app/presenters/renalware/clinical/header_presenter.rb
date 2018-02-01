require_dependency "renalware"
require "attr_extras"

module Renalware
  module Clinical
    class HeaderPresenter
      pattr_initialize :patient
      delegate :measurement, :date, to: :most_recent_weight, prefix: true
      delegate :measurement, :date, to: :most_recent_height, prefix: true
      delegate :measurement, :date, to: :most_recent_blood_pressure, prefix: true

      def latest_pathology
        @pathology ||= pathology_current_observation_set.values
      end

      def bmi
        BMI.new(
          height: most_recent_height_measurement,
          weight: most_recent_weight_measurement
        ).to_f
      end

      private

      def most_recent_weight
        Clinics::ClinicVisit.most_recent_weight_for(patient)
      end

      def most_recent_height
        Clinics::ClinicVisit.most_recent_height_for(patient)
      end

      def most_recent_blood_pressure
        Clinics::ClinicVisit.most_recent_blood_pressure_for(patient)
      end

      def pathology_current_observation_set
        pathology_patient.current_observation_set || Pathology::NullObservationSet.new
      end

      def pathology_patient
        Pathology.cast_patient(patient)
      end
    end
  end
end
