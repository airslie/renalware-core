require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def main_recipient_name
        main_recipient.to_s || ""
      end
    end
  end
end
