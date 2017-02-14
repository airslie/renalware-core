require_dependency "renalware/base_controller"

# Note we rely on template inheritance with this MDM Base class ie subclasses (e.g.
# HD::MDMPatientsController) can override templates and partials (e.g. add a _filters partial
# or override the _patient partial to replace what is displayed in the table)
# Otherwise the default template location is of course app/views/renalware/mdm_patients.
module Renalware
  class MDMPatientsController < BaseController
    include PresenterHelper

    def render_index(modalities:, page_title:, view_proc:)
      patients = Patients::MDMPatientsQuery.call(modality_names: modalities).page(params[:page])
      authorize patients
      presenter = MDMPatientsPresenter.new(
        patients: patients,
        page_title: page_title,
        view_proc: view_proc
      )
      render :index, locals: { presenter: presenter }
    end
  end
end
