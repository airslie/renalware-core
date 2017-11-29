require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsQuery
        include ModalityScopes
        MODALITY_NAMES = ["LCC"].freeze
        DEFAULT_SEARCH_PREDICATE = "ure_date ASC".freeze
        attr_reader :q, :relation, :named_filter

        # modality_names: eg "HD" or "PD"
        def initialize(relation: Patient.all, named_filter: nil, q: nil)
          @q = q || {}
          @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
          @relation = relation
          @named_filter = named_filter || :none
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
              .with_current_modality_matching(MODALITY_NAMES)
              .public_send(named_filter.to_s)
              .search(q)
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
