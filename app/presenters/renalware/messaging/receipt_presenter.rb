require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class ReceiptPresenter < SimpleDelegator
      def message
        @message ||= Messaging::InternalMessagePresenter.new(super)
      end
    end
  end
end
