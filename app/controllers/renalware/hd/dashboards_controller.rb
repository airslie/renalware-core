require "collection_presenter"

module Renalware
  module HD
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        profile = Profile.for_patient(@patient).first_or_initialize
        @preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
        @profile = ProfilePresenter.new(profile, preference_set: @preference_set)
        sessions = Session.for_patient(@patient).limit(10).ordered
        @sessions = CollectionPresenter.new(sessions, SessionPresenter)
        @dry_weights = DryWeightsCollectionPresenter.new(@patient).latest
      end
    end
  end
end
