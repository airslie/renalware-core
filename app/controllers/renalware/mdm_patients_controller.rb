require_dependency "renalware/base_controller"

# Note we rely on template inheritance with this MDM Base class i.e. subclasses (e.g.
# HD::MDMPatientsController) can override templates and partials (e.g. add a _filters partial
# or override the _patient partial to replace what is displayed in the table).
# Otherwise the default template location is of course app/views/renalware/mdm_patients.
module Renalware
  class MDMPatientsController < BaseController
    include PresenterHelper

    def render_index(**args)
      presenter = BuildPresenter.new(params: params, **args).call
      authorize presenter.patients
      render :index, locals: { presenter: presenter }
    end

    class BuildPresenter
      attr_reader :modalities, :page_title, :view_proc, :patient_relation, :params

      def initialize(**args)
        @modalities = args.fetch(:modalities)
        @page_title = args.fetch(:page_title)
        @view_proc = args.fetch(:view_proc)
        @patient_relation = args.fetch(:patient_relation)
        @params = args.fetch(:params)
      end

      def call
        MDMPatientsPresenter.new(
          patients: patients,
          page_title: page_title,
          view_proc: view_proc,
          q: query.search
        )
      end

      private

      def query
        @query ||= Patients::MDMPatientsQuery.new(relation: patient_relation,
                                                  modality_names: modalities,
                                                  q: params[:q])
      end

      def patients
        @patients ||= query.call.page(params[:page])
      end
    end
  end
end
