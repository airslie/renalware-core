# frozen_string_literal: true

require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugType < GlobalRule
          validate :drug_type_present

          def observation_required_for_patient?(patient, _date)
            patient.drugs.flat_map(&:drug_types).include?(drug_type)
          end

          def to_s
            "prescribed drugs include #{drug_type.name}"
          end

          private

          def drug_type
            @drug_type ||= Drugs::Type.find_by(id: param_id)
          end

          def drug_type_present
            return if drug_type.present?
            errors.add(:param_id, "param_id must be the id of a DrugType")
          end
        end
      end
    end
  end
end
