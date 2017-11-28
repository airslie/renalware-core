require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMController < Renalware::MDMController
        def show
          authorize patient
          mdm_presenter = MDMPresenter.new(patient: patient, view_context: view_context)
          render_show(mdm_presenter: mdm_presenter)
        end
      end
    end
  end
end
