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
          Renalware::UKRDC::XmlRenderer.new(locals: { patient: patient_presenter }).call
        end

        def patient_presenter
          patient = Renalware::Patient.find_by!(secure_id: params[:id])
          authorize patient
          changes_since = params.fetch(:changes_since, "2018-01-01")
          Renalware::UKRDC::PatientPresenter.new(patient, changes_since: changes_since)
        end
      end
    end
  end
end
