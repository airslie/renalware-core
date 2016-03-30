require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for defining the set of observation descriptions that
    # are relevant to pathology in the renal care domain
    #
    class RelevantObservationDescription
      def self.all
        ObservationDescription.for(codes)
      end

      def self.codes
        %w(
          HGB MCV MCH RETA HYPO WBC LYM NEUT PLT
          ESR CRP FER FOL B12 URE CRE EGFR NA POT
          BIC CCA PHOS PTHI TP GLO ALB URAT BIL
          ALT AST ALP GGT BGLU HBA HBAI CHOL HDL
          LDL TRIG TSH CK URR CRCL UREP AL
        )
      end
    end
  end
end
