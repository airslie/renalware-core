require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugCategory < GlobalRule
          def observation_required_for_patient?(patient)
            (patient.drugs.map(&:id) & drug_ids).any?
          end

          def to_s
            "prescribed drugs include #{drug_category.name}"
          end

          private

          def drug_ids
            drug_category.drugs.map(&:id)
          end

          def drug_category
            DrugCategory.find(param_id)
          end
        end
      end
    end
  end
end
