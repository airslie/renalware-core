require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class WaitListsController < BaseController
      def show
        query = Registrations::WaitListQuery.new(quick_filter: params[:filter], q: params[:q])
        @registrations = query.call.page(params[:page]).per(50)
        @q = query.search
        authorize @registrations
      end
    end
  end
end
