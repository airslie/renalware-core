require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Weekly < Frequency
        def exceeds?(days)
          days >= 7
        end
      end
    end
  end
end
