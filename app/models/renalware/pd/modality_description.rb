require_dependency "renalware/pd"

module Renalware
  module PD
    class ModalityDescription < Modalities::Description
      def to_sym
        :pd
      end
    end
  end
end
