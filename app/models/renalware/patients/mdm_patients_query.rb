module Renalware
  module Patients
    class MDMPatientsQuery
      attr_reader :modality_names, :q, :relation

      # modality_names: eg "HD" or ["APD", "CAPD", "PD"]
      def initialize(modality_names:, q:, relation: Patient.all)
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
            .extending(Scopes)
            .with_current_modality_matching(modality_names)
            .includes(:modality_description)
            .search(q)
        end
      end

      module Scopes
        def with_current_modality_matching(modality_names)
          joins(:modality_descriptions)
            .where(
              modality_descriptions: {
                name: Array(modality_names)
              },
              modality_modalities: {
                state: "current",
                ended_on: nil
              })
        end
      end
    end
  end
end
