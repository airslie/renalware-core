require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Base
            def initialize(patient, _param_id, _param_comparison_operator, _param_comparison_value)
              @patient = patient
            end

            def required?
              (@patient.drugs.map(&:id) & drug_ids).any?
            end

            def drug_ids
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
