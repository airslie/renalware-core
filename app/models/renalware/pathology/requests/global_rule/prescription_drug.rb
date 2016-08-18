require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrug < GlobalRule
          def required?
            @patient.drugs.include?(drug)
          end

          def to_s
            "prescribed drugs include #{drug.name}"
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
