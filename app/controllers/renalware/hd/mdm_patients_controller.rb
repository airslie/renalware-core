# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        # query = HD::MDMPatientsQuery.new(q: params[:q])
        # render_index(
        #   query: query,
        #   page_title: t(".page_title"),
        #   view_proc: ->(patient) { patient_hd_mdm_path(patient) },
        #   patient_presenter_class: HD::PatientPresenter
        # )

        filter_form = HD::MDMPatientsForm.new(filter_form_params)

        # query = HD::MDMPatientsQuery.new(
        #   relation: HD::Patient.eager_load(hd_profile: [:hospital_unit]),
        #   params: filter_form.ransacked_parameters
        # )

        query = HD::MDMPatientsQuery.new(params: filter_form.ransacked_parameters)

        render_index(filter_form: filter_form,
                     query: query,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_hd_mdm_path(patient) },
                     patient_presenter_class: HD::PatientPresenter)
      end

      private

      def filter_form_params
        params.permit(q: [:schedule_definition_ids, :hospital_unit_id])[:q]
      end

      def render_index(filter_form:, **args)
        presenter = build_presenter(params: params, **args)
        authorize presenter.patients
        render(
          :index,
          locals: { presenter: presenter, filter_form: filter_form }
        )
      end
    end
  end
end
