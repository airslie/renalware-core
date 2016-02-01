module Renalware
  module Hd
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        @preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
      end
    end
  end
end
