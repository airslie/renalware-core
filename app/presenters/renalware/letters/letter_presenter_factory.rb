require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPresenterFactory
      def self.new(letter)
        return letter if letter.is_a?(LetterPresenter)
        LetterPresenter.const_get(letter.class.name.demodulize).new(letter)
      end
    end
  end
end
