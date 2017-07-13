module Renalware
  module HD
    class MDMPatientsController < Renalware::MDMPatientsController

      def render_index(**args)
        presenter = build_presenter(params: params, **args)
        authorize presenter.patients
        render :index, locals: { presenter: presenter }
      end

      def index
        render_index(query: MDMPatientsQuery.new(q: params[:q]),
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_hd_mdm_path(patient) },
                     patient_presenter_class: HD::PatientPresenter)
      end
    end
  end
end
