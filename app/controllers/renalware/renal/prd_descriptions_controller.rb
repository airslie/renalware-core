require_dependency "renalware/renal"

module Renalware
  module Renal
    class PRDDescriptionsController < BaseController
      skip_after_action :verify_authorized, only: [:search]

      def search
        @prd_descriptions = PRDDescriptions::SearchQuery.new(term: params[:term]).call
      end
    end
  end
end
