require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class ReceiptPolicy < BasePolicy
      def mark_as_read?
        update?
      end
    end
  end
end
