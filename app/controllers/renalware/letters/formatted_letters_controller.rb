# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_action :load_patient

      layout "renalware/layouts/letter"

      def show
        letter = find_letter(params[:letter_id])
        letter = present_letter(letter)

        respond_to do |format|
          format.html { render locals: { letter: letter } }
          format.pdf  { render_pdf_simple(letter) }
          format.rtf  { render_rtf(letter) }
        end
      end

      # GET .pdf
      # Prints with a separate address page before each instance of the letter, so that the printed
      # output can be inserted into an envelope stuffer.
      def print
        raise "fail"
        letter = find_letter(params[:letter_id])
        letter = present_letter(letter)
        render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
      end

      private

      def find_letter(id)
        @patient.letters
          .with_patient
          .with_main_recipient
          .with_cc_recipients
          .find(id)
      end

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def render_pdf_simple(letter)
        render_pdf(renderer: PdfRenderer, letter: letter)
      end

      def render_pdf_as_collated_address_sheet_and_letter_for_each_recipient(letter)
        send_data(
          CollatedAddressSheetAndLetterPdfRenderer.call(letter),
          filename: letter.pdf_filename,
          type: "application/pdf",
          disposition: disposition
        )
      end

      def render_pdf
        send_data(
          PdfRenderer.call(letter),
          filename: letter.pdf_filename,
          type: "application/pdf",
          disposition: disposition
        )
      end

      def render_rtf(letter)
        RTFRenderer.new(letter, self).render
      end

      def disposition
        params.fetch("disposition", "attachment")
      end
    end
  end
end
