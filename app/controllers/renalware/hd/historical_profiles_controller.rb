require_dependency "renalware/hd/base_controller"
require "collection_presenter"

module Renalware
  module HD
    class HistoricalProfilesController < BaseController
      include PresenterHelper

      def show
        profile = Profile.deleted.for_patient(patient).find_by!(id: params[:id])
        authorize profile
        render locals: {
          patient: patient,
          profile: ProfilePresenter.new(profile)
        }
      end

      def index
        profiles = Profile.deleted.ordered.for_patient(patient)
        authorize profiles
        render locals: {
          patient: patient,
          profiles: present(profiles, ProfilePresenter)
        }
      end
    end
  end
end
