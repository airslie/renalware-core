require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ApprovedLetterPolicy < LetterPolicy
      delegate :recipients, to: :letter

      def complete?
        true
      end

      def email_to_gp?
        gp_is_a_recipient? && patient_has_a_practice_email?
      end

      private

      def practice
        letter.patient.practice
      end

      def gp_is_a_recipient?
        letter.recipients.find(&:primary_care_physician?)
      end

      def patient_has_a_practice_email?
        practice&.email.present?
      end
    end
  end
end
