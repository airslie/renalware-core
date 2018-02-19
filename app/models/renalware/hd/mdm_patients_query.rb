module Renalware
  module HD
    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = "HD".freeze
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc".freeze
      attr_reader :q, :relation

      def initialize(relation: HD::Patient.all, q:)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
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
            .extending(PatientPathologyScopes)
            .with_current_pathology
            .with_current_modality_matching(MODALITY_NAMES)
            .search(q)
        end
      end
    end
  end
end
