# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class LiveDonorsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        query = LiveDonorsQuery.new(params[:q])
        live_donors = query.call.page(page).per(per_page || 50)

        authorize live_donors
        render locals: {
          live_donors: live_donors,
          q: query.search
        }
      end
    end
  end
end
