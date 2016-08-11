require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Alucaps
            DRUG_IDS = [102, 103]

            def initialize(patient, _param_id, _param_comparison_operator, _param_comparison_value)
              @patient = patient
            end

            def required?
              (@patient.drugs.map(&:id) & DRUG_IDS).any?
            end
          end
        end
      end
    end
  end
end
