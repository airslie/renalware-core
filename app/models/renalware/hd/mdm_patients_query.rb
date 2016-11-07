module Renalware
  module HD
    class MDMPatientsQuery

      def self.call(relation = Renalware::HD::Patient.all)
        relation
          .extending(Scopes)
          .with_current_hd_modality
      end

      module Scopes

        def with_current_hd_modality
          joins(:modality_descriptions)
            .where(modality_descriptions: { name: "HD" },
                   modality_modalities: { state: "current" })
        end
      end
    end
  end
end
