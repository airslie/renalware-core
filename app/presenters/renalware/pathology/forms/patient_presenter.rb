require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Forms
      class PatientPresenter < SimpleDelegator
        def initialize(patient, clinic)
          @clinic = clinic
          super(patient)
        end

        def self.wrap(patients, clinic)
          patients.map do |patient|
            new(patient, clinic)
          end
        end

        def global_requests_by_lab
          @global_requests_by_lab ||=
            required_observation_requests(@clinic)
              .group_by { |request_description| request_description.lab.name }
        end

        def patient_requests_by_lab
          @patient_requests_by_lab ||=
            required_patient_pathology
              .group_by { |patient_rule| patient_rule.lab.name }
        end

        def has_global_requests?
          global_requests_by_lab.any?
        end

        def has_patient_requests?
          patient_requests_by_lab.any?
        end

        def has_tests_required?
          global_requests_by_lab.any? || patient_requests_by_lab.any?
        end
      end
    end
  end
end
