module Renalware
  module Accesses
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        current_access = Access.current_for_patient(@patient)
        @current_access = AccessPresenter.new(current_access)
        @accesses = Access.for_patient(@patient).ordered - [@current_access]
      end
    end
  end
end
