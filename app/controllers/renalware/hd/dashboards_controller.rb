require "collection_presenter"
require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DashboardsController < BaseController
      before_filter :load_patient

      def show
        preference_set = PreferenceSet.for_patient(@patient).first_or_initialize
        access_profile = Renalware::Accesses.cast_patient(@patient).current_profile
        profile = Profile.for_patient(@patient).first_or_initialize
        sessions = Session.for_patient(@patient).limit(10).ordered
        dry_weights = DryWeight.for_patient(@patient).limit(10).includes(:assessor).ordered

        render locals: {
          preference_set: preference_set,
          profile: ProfilePresenter.new(profile, preference_set: preference_set),
          access: Accesses::ProfilePresenter.new(access_profile),
          sessions: CollectionPresenter.new(sessions, SessionPresenter),
          dry_weights: CollectionPresenter.new(dry_weights, DryWeightPresenter)
        }
      end
    end
  end
end
