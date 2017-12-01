require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class DonorModalityDescription < Modalities::Description
      def to_sym
        :transplant
      end
    end
  end
end
