# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class DashboardsController < BaseController
      def show
        authorize [:renalware, :virology, :dashboard], :show?
        render locals: { dashboard: DashboardPresenter.new(patient) }
      end

      private

      def vaccinations
        CollectionPresenter.new(
          Vaccination.for_patient(patient),
          Events::EventPresenter
        )
      end
    end
  end
end
