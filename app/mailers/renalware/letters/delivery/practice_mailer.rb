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

          mail(
            to: to,
            subject: "Test",
            from: Renalware.config.default_from_email_address
          )
        end

        private

        def validate_letter(letter)
          raise Delivery::PatientHasNoPracticeError if letter.patient&.practice.blank?
        end
      end
    end
  end
end
