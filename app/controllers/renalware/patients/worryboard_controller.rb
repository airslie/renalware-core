# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class WorryboardController < BaseController
      include Renalware::Concerns::Pageable

      def show
        authorize Worry, :index?
        query = WorryQuery.new(query_params)
        worries = query.call.page(page).per(per_page)
        render locals: {
          query: query.search,
          worries: worries,
          modalities: Modalities::Description.order(:name)
        }
      end

      private

      def query_params
        params.fetch(:q, {})
      end
    end
  end
end
