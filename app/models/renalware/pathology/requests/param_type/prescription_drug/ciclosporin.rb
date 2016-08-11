require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Ciclosporin < Base
            DRUG_IDS = [512, 513, 515, 2658, 2659, 2663].freeze

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
