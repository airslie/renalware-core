require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class HistoricalObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        presenter = ViewHistoricalObservations.new(@patient, description_codes).call

        render :index, locals: {
          rows: presenter.to_a,
          number_of_records: presenter.limit
        }
      end

      private

      class ArchivedObservationDescription
        def to_a
          %w(
            HGB MCV MCH RETA HYPO WBC LYM NEUT PLT
            ESR CRP FER FOL B12 URE CRE EGFR NA POT
            BIC CCA PHOS PTHI TP GLO ALB URAT BIL
            ALT AST ALP GGT BGLU HBA HBAI CHOL HDL
            LDL TRIG TSH CK URR CRCL UREP AL
          )
        end
      end

      def description_codes
        ArchivedObservationDescription.new.to_a
      end
    end
  end
end
