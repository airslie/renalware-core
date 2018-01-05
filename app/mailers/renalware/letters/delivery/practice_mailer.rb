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
          attachments["letter.pdf"] = read_from_cache_or_generate_pdf_letter(letter_presenter)

          mail(
            to: to,
            subject: "Test",
            from: Renalware.config.default_from_email_address
          )
        end

        def validate_letter(letter)
          raise Delivery::PatientHasNoPracticeError if letter.patient&.practice.blank?
        end

        def read_from_cache_or_generate_pdf_letter(letter)
          PdfLetterCache.fetch(letter) { Letters::PdfRenderer.call(letter) }
        end
      end
    end
  end
end
