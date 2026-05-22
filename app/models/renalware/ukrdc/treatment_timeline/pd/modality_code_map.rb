module Renalware
  module UKRDC
    module TreatmentTimeline
      module PD
        class ModalityCodeMap
          def code_for_pd_regime(regime)
            ModalityCode.find_by!(description: description_for(regime))
          end

          private

          def description_for(regime)
            return "CAPD" if regime&.pd_type == :capd

            "APD"
          end
        end
      end
    end
  end
end
