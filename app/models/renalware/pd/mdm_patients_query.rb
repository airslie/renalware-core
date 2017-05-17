module Renalware
  module PD
    class MDMPatientsQuery
      include ModalityScopes
      MODALITY_NAMES = "PD".freeze
      attr_reader :q, :relation

      def initialize(relation: PD::Patient.all, q:)
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
            .with_current_modality_matching(MODALITY_NAMES)
            .with_current_key_pathology
            .search(q)
        end
      end

      module Scopes

        def with_current_key_pathology
          includes(:current_key_observation_set) # . joins(:current_key_observation)
        end
      end
    end
  end
end
