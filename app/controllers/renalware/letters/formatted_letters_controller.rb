require_dependency "renalware/letters"

module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_filter :load_patient

      layout "renalware/layouts/letter"

      def show
        letter = @patient.letters.find(params[:letter_id])
        @letter = present_letter(letter)
        @content = @letter.content

        respond_to do |format|
          format.html
          format.pdf { render_pdf(@letter) }
        end
      end

      private

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def render_pdf(letter)
        render(pdf_options.merge(pdf: letter.pdf_filename, disposition: "attachment"))
      end

      def pdf_options
        {
          page_size: "A4",
          layout: "renalware/layouts/letter",
          footer: {
            font_size: 8,
            right: "page [page] of [topage]"
          }
        }
      end
    end
  end
end
