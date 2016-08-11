require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Cinacalcet < Base
            DRUG_IDS = [520]

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
