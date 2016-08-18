require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugType < Base
          def required?
            @patient.drugs.flat_map(&:drug_types).include?(drug_type)
          end

          def to_s
            "prescribed drugs include #{drug_type.name}"
          end

          private

          def drug_type
            @drug_type ||= Renalware::Drugs::Type.find(@param_id)
          end
        end
      end
    end
  end
end
