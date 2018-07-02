# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class HomeDeliverablesController < BaseController
      include Renalware::Concerns::PdfRenderable

      def index
        respond_to do |format|
          format.pdf do
            prescriptions = patient.prescriptions
            authorize prescriptions
            options = default_pdf_options.merge!(
              pdf: pdf_filename,
              locals: { patient: patient, prescriptions: prescriptions }
            )
            render options
          end
        end
      end

      private

      def pdf_filename
        "#{patient.local_patient_id} prescriptions-for-home-delivery"
      end
    end
  end
end
