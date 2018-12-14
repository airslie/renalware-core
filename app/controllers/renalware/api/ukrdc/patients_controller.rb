# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module API
    module UKRDC
      class PatientsController < BaseController
        respond_to :xml

        def show
          respond_to do |format|
            format.xml { render xml: patient_ukrdc_xml }
          end
        end

        private

        def patient_ukrdc_xml
          result = attempt_to_generate_patient_ukrdc_xml
          if result.failure?
            handle_invalid_xml
          else
            result.xml
          end
        end

        def attempt_to_generate_patient_ukrdc_xml
          Renalware::UKRDC::XmlRenderer.new(locals: { patient: patient_presenter }).call
        end

        def patient_presenter
          patient = Renalware::Patient.find_by!(secure_id: params[:id])
          authorize patient
          changes_since = params.fetch(:changes_since, "2018-01-01")
          Renalware::UKRDC::PatientPresenter.new(patient, changes_since: changes_since)
        end

        # TODO: Think about how to handle this. Maybe raising an error here is sufficient as the
        # caller can handle the errors and log them. Or we could render an XML file with the
        # errors in it.
        def handle_invalid_xml(result)
          raise(ArgumentError, result.validation_errors) if result.failure?
        end
      end
    end
  end
end
