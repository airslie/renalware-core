require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Tacrolimus < Base
            DRUG_IDS = [49, 55, 2104, 2394, 2395, 2398, 2660, 2661, 2662].freeze

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
