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
          "AFP","ALB","ALT","AL","AMY","ALP","ASM","AST","B12","BIL","CAL", "CCA",
          "CHOL","CK","CRCL","CRE","CRP","CU","CYA","ESRR","FER","FIB","FOL","GGT",
          "GLO","BGLU","HBA","HBAI","HB","BIC","HCO3","HDL","HYPO","LYM","NEUT","PHOS",
          "RETA","POT","LDL","MCH", "MCV","MG","NA","PGLU","PLT","PTHI","TP","TRIG",
          "TSH","URAT","UREP","URE","URR"," WBC","ACRA","PCRAT"
        ]
      end
    end
  end
end
