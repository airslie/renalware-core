require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class MDMController < Renalware::MDMController
      before_action :load_patient

      def show
        mdm_presenter = PD::MDMPresenter.new(patient: patient, view_context: view_context)
        render_show(mdm_presenter: mdm_presenter)
      end
    end
  end
end
