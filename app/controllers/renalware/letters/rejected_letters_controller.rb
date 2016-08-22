require_dependency "renalware/letters"

module Renalware
  module Letters
    class RejectedLettersController < Letters::BaseController
      before_filter :load_patient

      def create
        letter = @patient.letters.pending.find(params[:letter_id])
        typed_letter = letter.reject(by: current_user)
        typed_letter.save!

        redirect_to patient_letters_letter_path(@patient, typed_letter), notice: t(".success")
      end
    end
  end
end
