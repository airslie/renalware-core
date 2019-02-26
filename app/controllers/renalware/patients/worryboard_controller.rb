# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::Pageable

      def show
        authorize Worry, :index?
        render locals: {
          query: worry_query.search,
          worries: worry_query.call.page(page).per(per_page),
          modalities: Modalities::Description.order(:name)
        }
      end

      private

      def worry_query
        @worry_query ||= begin
          WorryQuery.new(
            query_params: query_params,
            patient_scope: policy_scope(Renalware::Patient)
          )
        end
      end

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
