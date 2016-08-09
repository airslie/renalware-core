require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          def initialize(patient, param_id, _param_comparison_operator, _param_comparison_value)
            @patient = patient
            @param_id = param_id.to_i
          end

          def required?
            @patient.drugs.include?(drug)
          end

          private

          def drug
            @drug ||= Renalware::Drugs::Drug.find(@param_id)
          end
        end
      end
    end
  end
end
