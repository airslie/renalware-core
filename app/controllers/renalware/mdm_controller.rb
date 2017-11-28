require_dependency "renalware"

module Renalware
  class MDMController < BaseController
    def render_show(mdm_presenter:)
      render :show, locals: {
        mdm: mdm_presenter
      }
    end
  end
end
