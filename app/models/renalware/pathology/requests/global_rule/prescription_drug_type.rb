require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugType < GlobalRule
          def observation_required_for_patient?(patient, _date)
            patient.drugs.flat_map(&:drug_types).include?(drug_type)
          end

          def to_s
            "prescribed drugs include #{drug_type.name}"
          end

          private

          def drug_type
            @drug_type ||= Drugs::Type.find(param_id)
          end
        end
      end
    end
  end
end
