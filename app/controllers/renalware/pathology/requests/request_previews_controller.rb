require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RequestPreviewsController < Pathology::BaseController
        before_filter :load_patients

        def create
          form_params = RequestAlgorithm::FormParamsFactory.new(raw_form_params).build
          request_forms = RequestAlgorithm::FormsFactory.new(@patients, form_params).build

          form_options = build_params_for_simple_form(form_params)

          render :create,
            layout: "renalware/layouts/printable",
            locals:{
              form_options: form_options,
              request_forms: request_forms,
              all_clinics: all_clinics,
              all_consultants: all_consultants
            }
        end

        private

        def build_params_for_simple_form(params)
          OpenStruct.new(
            patient_ids: raw_form_params[:patient_ids],
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
          patient_ids = raw_form_params[:patient_ids].map(&:to_i)
          @patients = Pathology::OrderedPatientQuery.new(patient_ids).call
          authorize Renalware::Patient
        end

        def raw_form_params
          params
            .fetch(:form_options, {})
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
