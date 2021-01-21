# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class UnmetPreferencesController < BaseController
      include PresenterHelper
      skip_after_action :verify_policy_scoped

      def index
        query = PatientsWithUnmetPreferencesQuery.new(query_params)
        patients = query.call.page(params[:page])
        authorize(patients)
        render locals: {
          query: query.search,
          patients: present(patients, UnmetPreferencesPresenter)
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
