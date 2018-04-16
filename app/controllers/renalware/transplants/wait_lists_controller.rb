require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class WaitListsController < BaseController
      include Renalware::Concerns::Pageable

      def show
        registrations = query.call.page(page).per(per_page || 50)
        authorize registrations
        render locals: {
          path_params: path_params,
          registrations: CollectionPresenter.new(registrations, WaitListRegistrationPresenter),
          q: query.search
        }
      end

      private

      def query
        @query ||= begin
          Registrations::WaitListQuery.new(
            named_filter: params[:named_filter],
            q: params[:q]
          )
        end
      end

      def path_params
        params.permit([:controller, :action, :named_filter])
      end
    end
  end
end
