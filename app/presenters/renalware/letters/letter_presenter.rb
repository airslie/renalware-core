require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def recipient_name
        recipient.name || ""
      end
    end
  end
end
