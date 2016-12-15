require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class ProfilesController < BaseController
      def show
        authorize patient
        render locals: {
          patient: patient,
          profile: Clinical::ProfilePresenter.new(patient)
        }
      end
    end
  end
end
