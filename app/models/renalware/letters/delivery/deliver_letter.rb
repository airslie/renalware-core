require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      # Responsible for delivering the letter according to recipient's preferred method:
      # - Email letter to practice if GP is a recip and the practice has an email addres
      # - Currently no other action taken, but this class could be extended to for example
      # - email contacts etc.
      class DeliverLetter
        pattr_initialize [:letter!]

        def call
          email_letter_to_the_patients_practice if email_letter_to_the_patients_practice?
        end

        def email_letter_to_the_patients_practice?
          LetterDeliveryPolicy.new(letter).email_letter_to_practice?
        end

        def email_letter_to_the_patients_practice
          PracticeMailer.patient_letter(
            letter: letter,
            to: practice_email_address
          ).deliver_later
        end

        def practice_email_address
          PracticeEmail.new(letter).address
        end
      end
    end
  end
end
