module Renalware
  class PRDDescriptionsController < BaseController
    skip_after_action :verify_authorized, only: [:search]

    def search
      query = PRDDescriptions::SearchQuery.new(term: params[:term])
      render json: query.call.to_json
    end
  end
end
