# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class CollatedAddressSheetAndLetterPdfRenderer
      OPTIONS = {
        page_size: "A4",
        footer: {
          font_size: 8,
          right: "Page [page] of [topage]"
        },
        encoding: "UTF-8"
      }.freeze

      attr_reader :letter

      def initialize(letter)
        @letter = letter.respond_to?(:to_html) ? letter : LetterPresenterFactory.new(letter)
      end

      def self.call(letter)
        new(letter).call
      end

      def call
        pdf = CombinePDF.new
        # render address sheet for main recipient
        pdf << CombinePDF.parse(render_cover_sheet_for(letter.main_recipient))
        pdf << CombinePDF.parse(letter_pdf_content)
        # output address cover sheet avd letter for each non-email cc
        letter.cc_recipients.each do |cc_recipient|
          # p "here"
          if cc_recipient.statment_to_indicate_letter_will_be_emailed.blank?
            pdf << CombinePDF.parse(render_cover_sheet_for(cc_recipient))
            pdf << CombinePDF.parse(letter_pdf_content)
          end
        end
        (pdf.to_pdf)
      end

      def letter_pdf_content
        @letter_pdf_content ||= WickedPdf.new.pdf_from_string(letter.to_html, OPTIONS)
      end

      def render_cover_sheet_for(recipient)
        WickedPdf.new.pdf_from_string(
          LettersController.new.render_to_string(
            partial: "/renalware/letters/formatted_letters/recipient_address_cover_sheet",
            locals: { recipient: recipient },
            encoding: "UTF-8"
          ),
          OPTIONS
        )
      end
    end
  end
end
