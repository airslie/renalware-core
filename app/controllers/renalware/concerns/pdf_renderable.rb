# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Concerns
    module PdfRenderable
      extend ActiveSupport::Concern

      included do
        protected

        def default_pdf_options
          {
            page_size: "A4",
            layout: "renalware/layouts/pdf",
            disposition: "inline",
            footer: {
              font_size: 8,
              right: "Page [page] of [topage]"
            },
            show_as_html: Rails.env.development? && params.key?(:debug),
            encoding: "UTF-8"
          }
        end

        # Render a Liquid template loaded from the database.
        # The template may have variable place holders w.g. {{ patient.name }} and these
        # are resolved by passing instance of Liquid Drops (presenters) in the variables hash.
        def render_liquid_template_to_pdf(template_name:, filename:, variables: nil)
          variables ||= default_liquid_variables
          body = System::RenderLiquidTemplate.call(template_name: template_name,
                                                   variables: variables)
          options = default_pdf_options.merge!(pdf: filename, locals: { body: body })
          render options
        end

        private

        # By default if no variables supplied, we insert the patient drop to allow basic patient
        # data to be accessed in the template with eg {{ patient.name }}
        # Note the has key must be a string and not a symbol.
        def default_liquid_variables
          { "patient" => Patients::PatientDrop.new(patient) }
        end
      end
    end
  end
end
