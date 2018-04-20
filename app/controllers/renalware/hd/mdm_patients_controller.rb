# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        query = HD::MDMPatientsQuery.new(
          relation: HD::Patient.eager_load(hd_profile: [:hospital_unit]),
          q: params[:q]
        )
        render_index(query: query,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_hd_mdm_path(patient) },
                     patient_presenter_class: HD::PatientPresenter)
      end

      private

      def render_index(**args)
        presenter = build_presenter(params: params, **args)
        authorize presenter.patients
        render :index, locals: { presenter: presenter }
      end
    end
  end
end
