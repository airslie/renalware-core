require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RequestPreviewsController < Pathology::BaseController
        before_filter :load_patients

        def create
          request_params = RequestAlgorithm::RequestParamsFactory.new(raw_request_params).build
          requests = RequestAlgorithm::RequestsFactory.new(@patients, request_params).build

          render :create,
            layout: "renalware/layouts/printable",
            locals:{
              request_html_form_params: build_params_for_html_form(request_params),
              requests: requests,
              all_clinics: all_clinics,
              all_consultants: all_consultants
            }
        end

        private

        def build_params_for_html_form(params)
          OpenStruct.new(
            patient_ids: raw_request_params[:patient_ids],
            clinic_id: params[:clinic].id,
            consultant_id: params[:consultant].id,
            telephone: params[:telephone]
          )
        end

        def all_clinics
          Renalware::Clinics::Clinic.ordered
        end

        def all_consultants
          Renalware::Pathology::Consultant.ordered
        end

        # NOTE: Preserve the order of the id's given in the params
        def load_patients
          patient_ids = raw_request_params[:patient_ids].map(&:to_i)
          @patients = Pathology::OrderedPatientQuery.new(patient_ids).call
          authorize Renalware::Patient
        end

        def raw_request_params
          params
            .fetch(:request, {})
            .permit(
              :consultant_id,
              :clinic_id,
              :telephone,
              patient_ids: []
            )
        end
      end
    end
  end
end
