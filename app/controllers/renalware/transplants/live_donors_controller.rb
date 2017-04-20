require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class LiveDonorsController < BaseController
      def index
        query = LiveDonorsQuery.new(params[:q])
        live_donors = query.call.page(params[:page]).per(50)

        authorize live_donors
        render locals: {
          live_donors: live_donors,
          q: query.search
        }
      end
    end
  end
end
