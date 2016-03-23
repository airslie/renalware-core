require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        observed_at_date_range = DetermineDateRangeQuery.new(patient: @patient).call
        observations = ObservationsWithinDateRangeQuery.new(patient: @patient, date_range: observed_at_date_range).call
        observation_descriptions = ObservationDescription.for(description_codes)
        presenter = ArchivedResultsPresenter.new(observations, observation_descriptions)

        render :index, locals: {
          rows: presenter.rows.to_a,
          number_of_records: DetermineDateRangeQuery.new(patient: @patient).limit
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
