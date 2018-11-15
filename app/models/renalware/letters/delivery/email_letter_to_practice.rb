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
          # Note we cast the letter back to the superclass Letters::Letter here to prevent
          # GlobalID from trying to load the letter using e.g. Letters::Approved.find(123), because
          # in the meantime the letter's class might have progressed to Letters::Completed in which
          # case GlobalId/ ActiveJob would not be able to find the letter!
          # Casting to Letters::Letter means in the delayed job the handler says e.g.
          #   - letter:
          #    _aj_globalid: gid://dummy/Renalware::Letters::Letter/3
          # which it turns out works fine when the letter is loaded by GlobalId/ActiveJob;
          # it correctly casts the letter to its STI type e.g. Letters::Approved in the job.
          # Note we are already in a tx here from the letterlistener so if we for instance
          # call deliver and not deliver_later, we will get a LetterIsNotApprovedOrCompletedError
          # error when it looks up the letter as its approved state has not yet been saved.
          # We could possibly use an async LetterListener and remove the async here.
          Letter.transaction do
            PracticeMailer.patient_letter(
              letter: letter.becomes(Letter),
              to: practice_email_address
            ).deliver_later # ! see comment

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
