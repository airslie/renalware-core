module Renalware
  module Admin
    class HeidiSessionsController < BaseController
      def index
        query = Heidi::SessionsQuery.new(query_params)
        sessions = query.call
        authorize Heidi::Session

        pagy, sessions = pagy(sessions)
        render locals: {
          letters_by_clinic_visit_id: letters_by_clinic_visit_id(sessions),
          pagy:,
          search: query.search,
          sessions:,
          users: User.order(:family_name, :given_name)
        }
      end

      private

      def query_params
        params.fetch(:q, {}).permit(:s, :status_eq, :user_id_eq).to_h
      end

      def letters_by_clinic_visit_id(sessions)
        clinic_visit_ids = sessions.filter_map(&:clinic_visit_id)

        Letters::Letter
          .where(event_type: Clinics::ClinicVisit.name, event_id: clinic_visit_ids)
          .index_by(&:event_id)
      end
    end
  end
end
