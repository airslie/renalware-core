module Renalware
  module HD
    class MDMPatientsQuery
      include ModalityScopes
      MODALITY_NAMES = "HD".freeze
      attr_reader :q, :relation

      def initialize(relation: HD::Patient.all, q:)
        @q = q
        @relation = relation
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          relation
            .includes(:hd_profile)
            .extending(ModalityScopes)
            .extending(Scopes)
            .with_current_key_pathology
            .with_current_modality_matching(MODALITY_NAMES)
            .search(q)
          # .order("pathology_current_key_observations.hgb_result asc")
        end
      end

      module Scopes

        def with_current_key_pathology
          eager_load(:current_key_observation_set) # .joins(:current_key_observation)
        end
      end
    end
  end
end
