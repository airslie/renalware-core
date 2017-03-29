require_dependency "renalware/letters"

module Renalware
  module Letters
    class FormattedLettersController < Letters::BaseController
      before_action :load_patient

      layout "renalware/layouts/letter"

      def show
        letter = find_letter(params[:letter_id])
        @letter = present_letter(letter)
        @content = @letter.content

        respond_to do |format|
          format.html
          format.pdf {
            disposition = params.fetch("disposition", "attachment")
            render_pdf(@letter, disposition)
          }
          format.rtf {
            disposition = "attachment;"
            filename = "yay.rtf"
            disposition += " filename=\"#{filename}\""
            headers["Content-Disposition"] = disposition

            html = render_to_string(
              template: "/renalware/letters/formatted_letters/show",
              locals: { letter: letter },
              format: :pdf
            )
            p html
            #converter = PandocRuby.new('# Markdown Title', :from => :markdown, :to => :rtf)
            send_data PandocRuby.new(html, :standalone).to_rtf,
                     type: "rtf",
                     filename: "yay.rtf"
            # render text: rtf

          }
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

      def render_pdf(letter, disposition)
        render pdf_options.merge(pdf: letter.pdf_filename, disposition: disposition)
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
