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
          format.pdf  { render_pdf(letter) }
          format.rtf  { render_rtf(letter) }
        end
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

      def render_pdf(letter)
        send_data(PdfRenderer.call(letter),
                  filename: letter.pdf_filename,
                  type: "application/pdf",
                  disposition: disposition)
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
