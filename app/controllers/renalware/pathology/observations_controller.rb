require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        query = ArchivedResultsQuery.new(patient: @patient)
        observations = query.call
        observation_descriptions = ObservationDescription.for(description_codes)
        presenter = ArchivedResultsPresenter.new(observations, observation_descriptions)

        render :index, locals: {
          rows: presenter.rows.to_a,
          number_of_records: query.limit
        }
      end

      private

      def description_codes
        [
          "HBG", "MCV", "MCH", "RETA", "HYPO", "WBC", "LYM", "NEUT", "PLT",
          "ESR", "CRP", "FER", "FOL", "B12", "URE", "CRE", "EGFR", "NA", "POT",
          "BIC", "CCA", "PHOS", "PTHI", "TP", "GLO", "ALB", "URAT", "BIL",
          "ALT", "AST", "ALP", "GGT", "BGLU", "HBA", "HBAI", "CHOL", "HDL",
          "LDL", "TRIG", "TSH", "CK", "URR", "CRCL", "UREP", "AL"
        ]
      end
    end
  end
end
