require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Yearly < Frequency
        def exceeds?(days)
          days >= 365
        end
      end
    end
  end
end
