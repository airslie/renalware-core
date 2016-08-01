require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Always < Frequency
        def exceeds?(_days)
          true
        end
      end
    end
  end
end
