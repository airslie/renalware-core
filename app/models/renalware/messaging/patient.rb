require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :messages

      def to_s
        super(:long)
      end
    end
  end
end
