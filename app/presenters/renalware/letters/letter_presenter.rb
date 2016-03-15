require_dependency "renalware/medications"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def recipient
        @_recipient ||= RecipientPresenter.new(super)
      end
    end
  end
end
