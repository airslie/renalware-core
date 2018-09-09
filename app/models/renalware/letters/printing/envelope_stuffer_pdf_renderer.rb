# frozen_string_literal: true

require "collection_presenter"

module Renalware
  module Letters
    module Printing
      # Renders a PDF for printing with interleaved address and letter pages for multiple recipients
      class EnvelopeStufferPdfRenderer
        # Note we can't support page numbers here as they would start on the first address page and
        # end on the last letter, so the last letter if there are 3 recipients might say
        # Page 5 of 6 on the address page and Page 6 of 6 on the letter.
        OPTIONS = {
          page_size: "A4",
          encoding: "UTF-8"
        }.freeze

        def self.call(letter)
          unless letter.respond_to?(:to_html)
            letter = LetterPresenterFactory.new(letter)
          end
          WickedPdf.new.pdf_from_string(
            LettersController.new.render_to_string(
              partial: "/renalware/letters/formatted_letters/envelope_stuffed_letter",
              locals: { letter: letter, recipients: PrintableRecipients.for(letter) },
              encoding: "UTF-8"
            ),
            OPTIONS
          )
        end
      end
    end
  end
end
