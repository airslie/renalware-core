# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class PETCompletionsController < Renalware::BaseController
      include Pagy::Backend

      def index
        query = PETResult.joins(:patient).order(performed_on: :desc).ransack(params[:q])
        pagy, results = pagy(query.result)
        authorize results
        render locals: { pagination: pagy, results: results, query: query }
      end
    end
  end
end
