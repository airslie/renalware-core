require_dependency "renalware/hd/base_controller"

module Renalware
  module Renal
    module LowClearance
      class MDMController < Renalware::MDMController
        before_action :load_patient

        def show
          mdm_presenter = MDMPresenter.new(patient: patient, view_context: view_context)
          render_show(mdm_presenter: mdm_presenter)
        end
      end
    end
  end
end
