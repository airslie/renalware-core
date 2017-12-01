require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsQuery
        include ModalityScopes
        DEFAULT_SEARCH_PREDICATE = "ure_date ASC".freeze
        attr_reader :query, :relation, :named_filter

        def initialize(relation: Patient.all, query: nil, named_filter: nil)
          @query = query || {}
          @named_filter = named_filter || :none
          @query[:s] = DEFAULT_SEARCH_PREDICATE if @query[:s].blank?
          @relation = relation
        end

        def call
          search.result
        end

        def search
          @search ||= begin
            relation
              .extending(PatientPathologyScopes)
              .extending(ModalityScopes)
              .extending(NamedFilterScopes)
              .with_current_key_pathology
              .with_current_modality_of_class(LowClearance::ModalityDescription)
              .public_send(named_filter.to_s)
              .search(query)
          end
        end

        module NamedFilterScopes
          def none
            self # NOOP
          end

          def on_worryboard
            joins("RIGHT OUTER JOIN patient_worries ON patient_worries.patient_id = patients.id")
          end

          def tx_candidates
            self
          end

          def urea
            where("pathology_current_key_observation_sets.ure_result::float >= 30")
          end

          def hgb_low
            where("pathology_current_key_observation_sets.hgb_result::float < 100")
          end

          def hgb_high
            where("pathology_current_key_observation_sets.hgb_result::float > 130")
          end
        end
      end
    end
  end
end
