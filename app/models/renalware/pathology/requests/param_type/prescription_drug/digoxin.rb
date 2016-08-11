require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Digoxin < Base
            DRUG_IDS = [769, 770, 771, 772]

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
