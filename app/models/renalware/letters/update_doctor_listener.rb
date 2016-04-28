require_dependency "renalware/letters"

module Renalware
  module Letters
    class UpdateDoctorListener
      def doctor_updated(doctor)
        letter_doctor = Letters.cast_doctor(doctor)
        refresh_pending_letters(letter_doctor)
      end

      private

      def refresh_pending_letters(doctor)
        doctor.recipients_in_pending_letter.each do |recipient|
          RefreshRecipient.build.call(recipient)
        end
      end
    end
  end
end
