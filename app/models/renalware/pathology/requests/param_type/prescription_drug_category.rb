require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrugCategory
          def initialize(patient, param_id, _param_comparison_operator, _param_comparison_value)
            @patient = patient
            @drug_category_id = param_id
          end

          def required?
            (@patient.drugs.map(&:id) & drug_ids).any?
          end

          private

          def drug_ids
            drug_category.drugs.map(&:id)
          end

          def drug_category
            Renalware::Pathology::Requests::DrugCategory.find(@drug_category_id)
          end
        end
      end
    end
  end
end
