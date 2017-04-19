require_dependency "renalware/hd/base_controller"
require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class MDMController < Renalware::MDMController
      before_action :load_patient

      def show
        mdm_presenter = Transplants::MDMPresenter.new(patient: patient, view_context: view_context)
        render_show(mdm_presenter: mdm_presenter)
      end
    end
  end
end
