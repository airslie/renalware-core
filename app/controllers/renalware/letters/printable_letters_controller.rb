# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class PrintableLettersController < Letters::BaseController
      def show
        letter = find_letter(params[:letter_id])
        authorize letter
        letter = present_letter(letter)
        render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
      end

      private

      def find_letter(id)
        patient.letters.completed
          .with_patient
          .with_main_recipient
          .with_cc_recipients
          .find(id)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
        # send_file(
        #   "/Users/tim/Desktop/pdf.pdf",
        #   filename: letter.pdf_filename,
        #   type: "application/pdf",
        #   disposition: disposition
        # )

        send_data(
          CollatedAddressSheetAndLetterPdfRenderer.call(letter),
          filename: letter.pdf_filename,
          type: "application/pdf",
          disposition: disposition
        )
      end

      def disposition
        params.fetch("disposition", "attachment")
      end
    end
  end
end
