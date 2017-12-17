module Renalware
  module PD
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
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
            .extending(PatientPathologyScopes)
            .with_current_modality_matching(MODALITY_NAMES)
            .with_current_pathology
            .left_joins(:current_observation_set)
            .search(q)
        end
      end
    end
  end
end
