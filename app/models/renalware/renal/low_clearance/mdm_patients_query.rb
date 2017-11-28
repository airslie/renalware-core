require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsQuery
        include ModalityScopes
        attr_reader :q, :relation

        # modality_names: eg "HD" or "PD"
        def initialize(relation: Patient.all, q:)
          @q = q
          @relation = relation
        end

        def call
          search.result
        end

        def search
          @search ||= begin
            relation
              .extending(Scopes)
              .with_current_key_pathology
              .search(q)
            # .order("pathology_current_key_observations.hgb_result asc")
          end
        end

        module Scopes
          def with_current_key_pathology
            includes(:current_key_observation_set) # .joins(:current_key_observation)
          end
        end
      end
    end
  end
end
