# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Clinics
    # TODO: Move this to a view?
    class CurrentObservations
      NULL_DATE = nil
      pattr_initialize :patient

      Observation = Struct.new(:date, :measurement)

      # Returns [date, weight]
      def weight
        @weight ||= begin
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("weight is not null")
                    .pluck(:date, :weight).first || []

          Observation.new(result.first, result.last)
        end
      end

      # Returns [date, height]
      def height
        @height ||= begin
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("height is not null")
                    .pluck(:date, :height).first || []

          Observation.new(result.first, result.last)
        end
      end

      # Returns [date, [systolic_bp, diastolic_bp]]
      def blood_pressure
        @blood_pressure ||= begin
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("systolic_bp is not null and diastolic_bp is not null")
                    .pluck(:date, :systolic_bp, :diastolic_bp).first || [nil, nil, nil]

          Observation.new(result[0], [result[1], result[2]])
        end
      end

      def bmi
        bmi = BMI.new(
          height: height.measurement,
          weight: weight.measurement
        )
        Observation.new(NULL_DATE, bmi.to_f)
      end
    end
  end
end
