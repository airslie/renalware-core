require "collection_presenter"

module Renalware
  module Accesses
    class DashboardsController < Accesses::BaseController
      def show
        authorize patient
        render locals: { dashboard: DashboardPresenter.new(patient) }
      end
    end
  end
end
