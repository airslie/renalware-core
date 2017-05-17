module Renalware
  module Patients
    class MDMPatientsQuery
      include ModalityScopes
      attr_reader :modality_names, :q, :relation

      # modality_names: eg "HD" or "PD"
      def initialize(relation: Patient.all, q:, modality_names:)
        @modality_names = modality_names
        @q = q
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .extending(ModalityScopes)
            .extending(Scopes)
            .with_current_key_pathology
            .with_current_modality_matching(modality_names)
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
