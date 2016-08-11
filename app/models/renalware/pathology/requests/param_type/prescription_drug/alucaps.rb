require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      module ParamType
        class PrescriptionDrug
          class Alucaps < Base
            DRUG_IDS = [102, 103].freeze

            def drug_ids
              DRUG_IDS
            end
          end
        end
      end
    end
  end
end
