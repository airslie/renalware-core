require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class Frequency
        def exceeds?(_days)
          raise NotImplementedError
        end

        def once?
          false
        end

        def to_s
          self.class.name.demodulize
        end
      end
    end
  end
end
