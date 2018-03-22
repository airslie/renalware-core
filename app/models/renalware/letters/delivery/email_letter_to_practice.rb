# frozen_string_literal: true

require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      # This is a utility class that a host app might want to use to send an approved letter
      # to the patient's practice.
      class EmailLetterToPractice
        pattr_initialize [:letter!]
        delegate :email_letter_to_practice?, :gp_recipient, to: :policy

        def self.call(letter)
          new(letter: letter).call
        end

        # Returns
        #   true: we have sent an email to the patient's practice
        #   false: the patient does not have a practice or the practice has no email address
        def call
          return false unless email_letter_to_practice?
          email_letter_to_the_patients_practice
          true
        end

        private

        def email_letter_to_the_patients_practice
          Letter.transaction do
            PracticeMailer.patient_letter(
              letter: letter,
              to: practice_email_address,
              recipient: nil # TODO
            ).deliver_later

            # Flag as sent
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
