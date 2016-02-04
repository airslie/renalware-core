module Renalware
  module HD
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        profile = Profile.for_patient(@patient).first_or_initialize
        @preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
        @profile = ProfilePresenter.new(profile, preference_set: @preference_set)
      end
    end
  end
end
