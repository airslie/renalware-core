require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class ProtocolsController < BaseController
      before_action :load_patient

      def show
        respond_to do |format|
          format.pdf {
            disposition = params.fetch("disposition", "inline")
            render_pdf(disposition)
          }
        end
      end

      private

      def render_pdf(disposition)
        render(
          pdf_options.merge(
            pdf: pdf_filename,
            disposition: disposition,
            print_media_type: true,
            locals: {
              protocol: ProtocolPresenter.new(patient, view_context)
            }
          )
        )
      end

      # Other options to consider:
      #  viewport_size: '1280x1024'
      #  disable_smart_shrinking: true
      def pdf_options
        {
          page_size: "A4",
          orientation: "Landscape",
          layout: "renalware/layouts/pdf",
          margin: { top: 10, bottom: 10, left: 10, right: 10 },
          footer: {
            font_size: 8
          },
          show_as_html: Rails.env.development? && params.key?("debug")
        }
      end

      def pdf_filename
        "#{patient.family_name}-#{patient.hospital_identifier.id}-protocol".upcase
      end
    end
  end
end
