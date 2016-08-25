require_dependency "renalware/letters"

module Renalware
  module Letters
    class CompletedLettersController < Letters::BaseController
      before_filter :load_patient

      def create
        letter = @patient.letters.approved.find(params[:letter_id])

        CompleteLetter.build(letter).call(by: current_user)

        redirect_to patient_letters_letter_path(@patient, letter), notice: t(".success")
      end
    end
  end
end
