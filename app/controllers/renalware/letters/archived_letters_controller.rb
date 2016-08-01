require_dependency "renalware/letters"

module Renalware
  module Letters
    class ArchivedLettersController < Letters::BaseController
      before_filter :load_patient

      def create
        letter = @patient.letters.typed.find(params[:letter_id])
        archived_letter = letter.archive(by: current_user)
        archived_letter.save!

        redirect_to patient_letters_letter_path(@patient, archived_letter), notice: t(".success")
      end
    end
  end
end
