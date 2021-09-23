# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class OngoingSessionsController < BaseController
      include Renalware::Concerns::Pageable
      skip_after_action :verify_policy_scoped

      def show
        query = Sessions::OngoingQuery.new(q: params[:q])
        sessions = query.call
          .includes(
            :hospital_unit, :signed_on_by, :signed_off_by,
            patient: { current_modality: [:description] }
          )
          .page(page).per(per_page || 15)
        authorize sessions
        render locals: { query: query.search, sessions: sessions }
      end
    end
  end
end
