require_dependency "renalware/letters"

module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_filter :load_patient

      layout "renalware/layouts/letter"

      def show
        letter = @patient.letters.find(params[:letter_id])
        @content = present_letter(letter).content

        respond_to do |format|
          format.html
          format.pdf { render_pdf }
        end
      end

      private

      def present_letter(letter)
        LetterPresenterFactory.new(letter)
      end

      def render_pdf
        render pdf_options.merge(pdf: "letter", disposition: "attachment")
      end

      def pdf_options
        {
          page_size: "A4",
          background: true,
          print_media_type: false,
          no_background: false,
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
