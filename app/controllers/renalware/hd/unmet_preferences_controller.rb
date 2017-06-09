require_dependency "renalware/hd"

module Renalware
  module HD
    class UnmetPreferencesController < BaseController
      include PresenterHelper

      def index
        patients = PatientsWithUnmetPreferencesQuery.new.call.page(params[:page])
        authorize(patients)
        render locals: {
          patients: present(patients, UnmetPreferencesPresenter)
        }
      end
    end
  end
end
