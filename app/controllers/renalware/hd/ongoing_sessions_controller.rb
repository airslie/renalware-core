# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class OngoingSessionsController < BaseController
      include Renalware::Concerns::Pageable

      def show
        query = Sessions::OngoingQuery.new(q: params[:q])
        sessions = query.call.page(page).per(per_page || 15)
        authorize sessions
        render locals: { query: query.search, sessions: sessions }
      end
    end
  end
end
