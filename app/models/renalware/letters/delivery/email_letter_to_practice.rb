require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      class EmailLetterToPractice
        pattr_initialize [:letter!]
        delegate :email_letter_to_practice?, :gp_recipient, to: :policy

        def self.call(letter)
          new(letter: letter).call
        end

        def call
          if email_letter_to_practice?
            email_letter_to_the_patients_practice_and_flag_as_sent
          end
        end

        private

        def email_letter_to_the_patients_practice_and_flag_as_sent
          Letter.transaction do
            mail = PracticeMailer.patient_letter(letter: letter, to: practice_email_address)
            mail.deliver_later
            gp_recipient.update(emailed_at: Time.zone.now)
          end
        end

        def practice_email_address
          PracticeEmail.new(letter).address
        end

        def policy
          @policy ||= DeliveryPolicy.new(letter)
        end
      end
    end
  end
end
