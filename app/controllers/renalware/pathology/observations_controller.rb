require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        query = Renalware::Pathology::ArchivedResultsQuery.new(patient: @patient).call
        observation_descriptions = Renalware::Pathology::ObservationDescription.for(description_codes.take(10))
        presenter = Renalware::Pathology::ArchivedResultsPresenter.new(
          query, observation_descriptions
        )

        render :index, locals: { results: presenter, observation_descriptions: observation_descriptions }
      end

      private

      def description_codes
        [
          'AFP','ALB','ALT','AL','AMY','ALP','ASM','AST','B12','BIL','CAL', 'CCA',
          'CHOL','CK','CRCL','CRE','CRP','CU','CYA','ESRR','FER','FIB','FOL','GGT',
          'GLO','BGLU','HBA','HBAI','HB','BIC','HCO3','HDL','HYPO','LYM','NEUT','PHOS',
          'RETA','POT','LDL','MCH', 'MCV','MG','NA','PGLU','PLT','PTHI','TP','TRIG',
          'TSH','URAT','UREP','URE','URR',' WBC','ACRA','PCRAT'
        ]
      end
    end
  end
end
