require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RequestsController < Pathology::BaseController
        before_filter :load_patients

        # NOTE: This needs to be POST since params[:patient_ids] may exceed url char limit in GET
        def new
          render :new,
            layout: "renalware/layouts/printable",
            locals:{
              request_html_form_params: request_params_for_html_form,
              requests: requests,
              all_clinics: Renalware::Clinics::Clinic.ordered,
              all_consultants: Renalware::Pathology::Consultant.ordered
            }
        end

        def create
          render :create,
            layout: false,
            locals:{
              request_html_form_params: request_params_for_html_form,
              requests: requests,
            }
        end

        private

        def request_params_for_html_form
          OpenStruct.new(
            patient_ids: raw_request_params[:patient_ids],
            clinic_id: request_params[:clinic].id,
            consultant_id: request_params[:consultant].id,
            telephone: request_params[:telephone]
          )
        end

        def requests
          RequestPresenter.present(
            Requests::RequestsFactory.new(@patients, request_params).build
          )
        end

        def request_params
          @request_params ||= Requests::RequestParamsFactory.new(raw_request_params).build
        end

        def raw_request_params
          params
            .fetch(:request, {})
            .permit(:consultant_id, :clinic_id, :telephone, patient_ids: [])
        end

        def load_patients
          patient_ids = raw_request_params[:patient_ids]
          @patients = Pathology::OrderedPatientQuery.new(patient_ids).call
          authorize Renalware::Patient
        end
      end
    end
  end
end
