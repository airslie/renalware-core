require_dependency "renalware/letters"

module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_filter :load_patient

      layout false

      def show
        letter = @patient.letters.find(params[:letter_id])
        content = present_letter(letter).content
        render text: content
      end

      private

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end
    end
  end
end
