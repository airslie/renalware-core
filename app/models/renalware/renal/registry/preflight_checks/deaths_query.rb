require_dependency "renalware/renal"

module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class DeathsQuery
          include ModalityScopes
          MODALITY_NAMES = %w(Death).freeze

          attr_reader :relation

          def initialize(relation = default_relation)
            @relation = relation
          end

          def default_relation
            Renalware::Patient
              .preload(current_modality: [:description])
              .all
              .order(family_name: :asc)
          end

          def call
            relation
              .extending(ModalityScopes)
              .with_current_modality_matching(MODALITY_NAMES)
              .joins("LEFT OUTER JOIN renal_profiles ON renal_profiles.patient_id = patients.id")
              .where("patients.first_cause_id is NULL AND renal_profiles.esrf_on IS NOT NULL")
          end

          def self.missing_data_for(patient)
            [
              :cause_of_death
            ]
          end
        end
      end
    end
  end
end
