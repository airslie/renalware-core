module Renalware
  module PD
    class MDMPatientsQuery
      include ModalityScopes
      MODALITY_NAMES = %w(PD APD CAPD).freeze
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
            .with_current_modality_matching(MODALITY_NAMES)
            .search(q)
        end
      end
    end
  end
end
