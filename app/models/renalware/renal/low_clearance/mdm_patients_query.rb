require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsQuery
        include ModalityScopes
        MODALITY_NAMES = ["LCC"].freeze
        attr_reader :q, :relation, :named_filter

        # modality_names: eg "HD" or "PD"
        def initialize(relation: Patient.all, named_filter: nil, q: {})
          @q = q
          @relation = relation
          @named_filter = named_filter || :none
        end

        def call
          search.result
        end

        def search
          @search ||= begin
            relation
              .extending(Scopes)
              .extending(ModalityScopes)
              .extending(NamedFilterScopes)
              .with_current_modality_matching(MODALITY_NAMES)
              .with_current_key_pathology
              .public_send(named_filter.to_s)
              .search(q)
            # .order("pathology_current_key_observations.hgb_result asc")
          end
        end

        module Scopes
          def with_current_key_pathology
            includes(:current_key_observation_set) # .joins(:current_key_observation)
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
            self
          end

          def hgb_low
            self
          end

          def hgb_high
            self
          end
        end
      end
    end
  end
end
