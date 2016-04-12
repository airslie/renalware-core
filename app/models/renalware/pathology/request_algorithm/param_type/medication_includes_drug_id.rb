require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class RequestAlgorithm
      module ParamType
        class MedicationIncludesDrugId
          def initialize(patient, drug_id, param_value)
            @patient = patient
            @drug_id = drug_id.to_i
          end

          def patient_requires_test?
            @patient.drugs
              .select { |drug| drug.id == @drug_id }
              .count > 0
          end
        end
      end
    end
  end
end
