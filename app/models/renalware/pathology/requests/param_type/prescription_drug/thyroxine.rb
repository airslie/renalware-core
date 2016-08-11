require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Thyroxine < Base
            DRUG_IDS = [1402, 1403, 1427, 1428].freeze

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
