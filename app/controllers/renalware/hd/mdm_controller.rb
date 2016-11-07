require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class MDMController < BaseController
      before_filter :load_patient

      def show
        render :show, locals: {
          mdm: MDMPresenter.new(patient: patient, view_context: view_context)
        }
      end
    end
  end
end
