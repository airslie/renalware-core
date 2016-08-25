require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrug < GlobalRule
          def observation_required_for_patient?(patient, _date)
            patient.drugs.include?(drug)
          end

          def to_s
            "prescribed drugs include #{drug.name}"
          end

          private

          def drug
            @drug ||= Drugs::Drug.find(param_id)
          end
        end
      end
    end
  end
end
