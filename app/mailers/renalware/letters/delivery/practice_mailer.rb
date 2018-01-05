require_dependency "renalware/letters"
require_relative "./errors"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      class PracticeMailer < ApplicationMailer
        def patient_letter(letter)
          letter_presenter = LetterPresenterFactory.new(letter)
          attachments["letter.pdf"] = read_from_cache_or_generate_pdf_letter(letter_presenter)

          mail(
            to: to,
            subject: "Test",
            from: Renalware.config.default_from_email_address
          )
        end

        def read_from_cache_or_generate_pdf_letter(letter)
          PdfLetterCache.fetch(letter) { Letters::PdfRenderer.call(letter) }
        end
      end
    end
  end
end
