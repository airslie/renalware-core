require_dependency "renalware/letters"

module Renalware
  module Letters
    class RecipientPresenterFactory
      def self.new(recipient)
        RecipientPresenter.const_get(recipient.state.classify).new(recipient)
      end
    end
  end
end
