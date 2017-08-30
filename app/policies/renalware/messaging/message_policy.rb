require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class MessagePolicy < BasePolicy
      def sent?
        index?
      end
    end
  end
end
