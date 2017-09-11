require_dependency "renalware/messaging"

module Renalware
  module Messaging
    module Internal
      class MessagePolicy < BasePolicy
        def sent?
          index?
        end
      end
    end
  end
end
