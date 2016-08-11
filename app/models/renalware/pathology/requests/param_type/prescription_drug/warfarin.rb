require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Thyroxine < Base
            DRUG_IDS = [2615, 2617, 2618]

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
