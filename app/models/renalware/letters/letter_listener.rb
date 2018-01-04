require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    class LetterListener
      # :reek:UtilityFunction
      def letter_approved(letter)
        Delivery::DeliverLetter.new(letter: letter).call
      end
    end
  end
end
