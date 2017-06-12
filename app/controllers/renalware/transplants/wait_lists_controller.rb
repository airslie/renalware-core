require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class WaitListsController < BaseController
      include Renalware::Concerns::Pageable

      def show
        query = Registrations::WaitListQuery.new(quick_filter: params[:filter], q: params[:q])
        registrations = query.call.page(page).per(per_page || 50)
        authorize registrations
        render locals: {
          path_params: path_params,
          registrations: registrations,
          q: query.search }
      end

      private

      def path_params
        params.permit([:controller, :action, :filter])
      end
    end
  end
end
