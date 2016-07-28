require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Monthly < Frequency
        def exceeds?(days)
          days >= 28
        end
      end
    end
  end
end
