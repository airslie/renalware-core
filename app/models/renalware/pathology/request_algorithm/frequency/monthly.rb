require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency::Monthly < Frequency
        def self.exceeds?(days)
          days >= 28
        end
      end
    end
  end
end
