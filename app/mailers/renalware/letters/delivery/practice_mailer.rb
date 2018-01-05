require_dependency "renalware/letters"
require "attr_extras"
require_relative "./errors"

module Renalware
  module Letters
    module Delivery
      class PracticeMailer < ApplicationMailer
        def patient_letter(letter:, to:)
          validate_letter(letter)
          letter_presenter = LetterPresenterFactory.new(letter)
          attachments["letter.pdf"] = Letters::PdfRenderer.call(letter_presenter)

          # Note here we render the content in a block so that we can use the locals: {..} syntax
          # which is cleaner than using @vars.
          mail(
            to: to,
            subject: "Test",
            from: Renalware.config.default_from_email_address,
            locals: locals_for(letter)
          ) { |format| format.text { render(locals: locals_for(letter)) } }
        end

        private

        def locals_for(_letter)
          {
            help_phone_number: Renalware.config.phone_number_on_letters,
            help_email_address: Renalware.config.default_from_email_address
          }
        end

        def validate_letter(letter)
          raise Delivery::PatientHasNoPracticeError if letter.patient&.practice.blank?
        end
      end
    end
  end
end
