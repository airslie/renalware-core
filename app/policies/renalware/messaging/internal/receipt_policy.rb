require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class ReceiptPolicy < BasePolicy
        def mark_as_read?
          update?
        end

        def unread?
          index?
        end

        def read?
          index?
        end

        def sent?
          index?
        end
      end
    end
  end
end
