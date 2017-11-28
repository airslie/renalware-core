require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsController < Renalware::MDMPatientsController
        def index
          render_index(query: MDMPatientsQuery.new(q: params[:q]),
                       page_title: t(".page_title"),
                       view_proc: ->(patient) { patient_renal_low_clearance_mdm_path(patient) })
        end
      end
    end
  end
end
