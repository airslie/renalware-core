require_dependency "renalware/pd"

module Renalware
  module PD
    class ModalityDescription < Modalities::Description
      def self.include?(record)
        exists?(description: record)
      end
    end
  end
end
