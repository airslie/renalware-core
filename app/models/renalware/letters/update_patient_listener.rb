require_dependency "renalware/letters"

module Renalware
  module Letters
    class UpdatePatientListener
      def patient_updated(patient)
        letter_patient = Letters.cast_patient(patient)
        refresh_pending_letters(letter_patient)
      end

      private

      def refresh_pending_letters(patient)
        patient.recipients_in_pending_letter.each do |recipient|
          RefreshRecipient.build.call(recipient)
        end
      end
    end
  end
end
