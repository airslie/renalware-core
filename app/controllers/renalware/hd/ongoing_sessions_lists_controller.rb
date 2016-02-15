module Renalware
  module HD
    class OngoingSessionsListsController < BaseController
      def show
        query = Sessions::OngoingQuery.new(q: params[:q])
        @sessions = query.call.page(params[:page]).per(15)
        authorize @sessions

        @q = query.search
      end
    end
  end
end
