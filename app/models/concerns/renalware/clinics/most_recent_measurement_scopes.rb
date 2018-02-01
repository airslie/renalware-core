require_dependency "renalware/letters"

module Renalware
  module Clinics
    module MostRecentMeasurementScopes
      extend ActiveSupport::Concern

      ClinicalObservation = Struct.new(:date, :measurement)

      class_methods do

        # Returns [date, weight]
        def most_recent_weight_for(patient)
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("weight is not null")
                    .pluck(:date, :weight).first || []

          ClinicalObservation.new(result.first, result.last)
        end

        # Returns [date, height]
        def most_recent_height_for(patient)
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("height is not null")
                    .pluck(:date, :height).first || []

          ClinicalObservation.new(result.first, result.last)
        end

        # Returns [date, [systolic_bp, diastolic_bp]]
        def most_recent_blood_pressure_for(patient)
          result = ClinicVisit
                    .most_recent_for_patient(patient)
                    .where("systolic_bp is not null and diastolic_bp is not null")
                    .pluck(:date, :systolic_bp, :diastolic_bp).first || [nil, nil, nil]

          ClinicalObservation.new(result[0], [result[1], result[2]])
        end
      end
    end
  end
end
