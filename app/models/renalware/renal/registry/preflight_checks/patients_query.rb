require_dependency "renalware/renal"

module Renalware
  module Renal
    module Registry
      module PreflightChecks
        class PatientsQuery
          include ModalityScopes
          MODALITY_NAMES = %w(HD PD Transplant).freeze
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
              .joins("LEFT OUTER JOIN hd_profiles ON hd_profiles.patient_id = patients.id")
              .joins("LEFT OUTER JOIN renal_profiles ON renal_profiles.patient_id = patients.id")
              .where(where_conditions)
          end

          def where_conditions
            <<-SQL.squish
              (patients.ethnicity_id is NULL)
              OR
              (renal_profiles.id IS NULL)
              OR
              (renal_profiles.prd_description_id IS NULL)
              OR
              (renal_profiles.first_seen_on IS NULL)
              OR
              (renal_profiles.document #>> '{comorbidities,ischaemic_heart_dis,status}' is null)
            SQL
          end

          # Putting this here for now so all incomplete data criteria is all in one place.
          # Build an array of symbols for all missing data identified by the above query
          # rubocop:disable Metrics/AbcSize
          def self.missing_data_for(patient)
            renal_profile = Renal.cast_patient(patient).profile
            missing = []
            missing << :ethnicity if patient.ethnicity_id.blank?
            missing << :prd if renal_profile&.prd_description_id.blank?
            missing << :first_seen_on if renal_profile&.first_seen_on.blank?
            if renal_profile&.document&.comorbidities&.ischaemic_heart_dis&.status.blank?
              missing << :comorbidities_at_esrf
            end
            missing
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
