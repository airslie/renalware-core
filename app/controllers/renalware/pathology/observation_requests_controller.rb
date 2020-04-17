# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequestsController < Pathology::BaseController
      include Renalware::Concerns::Pageable
      before_action :load_patient

      def index
        observation_requests = find_observation_requests
        render locals: {
          observation_requests: observation_requests.result.page(page).per(per_page),
          search: observation_requests,
          obr_filter_options: obr_filter_options,
          patient: @patient
        }
      end

      def show
        observation_request = find_observation_request

        render locals: { observation_request: observation_request, patient: @patient }
      end

      private

      # Select just the OBR description ids and codes that have been associated with this patient.
      # We'll uses them to build a filter dropdown list.
      def obr_filter_options
        @patient.observation_requests
          .joins(:description)
          .order("pathology_request_descriptions.code asc")
          .pluck(
            Arel.sql(
              "distinct on(pathology_request_descriptions.code) pathology_request_descriptions.code"
            ),
            "pathology_request_descriptions.id",
            "pathology_request_descriptions.name"
          )
      end

      def find_observation_requests
        @patient.observation_requests
          .includes(:description)
          .ordered
          .ransack(params[:q])
      end

      def find_observation_request
        @patient.observation_requests
          .includes(observations: :description)
          .find(params[:id])
      end
    end
  end
end
