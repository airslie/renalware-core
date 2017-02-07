module Renalware
  module Patients
    class MDMPatientsQuery
      # modality_names: eg "HD" or ["APD", "CAPD", "PD"]
      def self.call(relation: Patient.all, modality_names:)
        relation
          .extending(Scopes)
          .with_current_modality_matching(modality_names)
          .includes(:modality_description)
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
