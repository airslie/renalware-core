#
# Render a Letter to PDF. Try and get it from the cachefirst
# Lean on Letters::HTMLRenderer which already renders the letter to html via
# LetterPresenter#content.
#
module Renalware
  module Letters
    class PdfRenderer
      OPTIONS = {
        page_size: "A4",
        footer: {
          font_size: 8,
          right: "Page [page] of [topage]"
        },
        encoding: "UTF-8"
      }.freeze

      def self.call(letter)
        unless letter.respond_to?(:to_html)
          letter = LetterPresenterFactory.new(letter)
        end
        PdfLetterCache.fetch(letter) do
          WickedPdf.new.pdf_from_string(letter.to_html, OPTIONS)
        end
      end
    end
  end
end
