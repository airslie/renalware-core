require_dependency "renalware/hd"

module Renalware
  module HD
    class ModalityDescription < Modalities::Description
      def self.include?(record)
        exists?(description: record)
      end
    end
  end
end
