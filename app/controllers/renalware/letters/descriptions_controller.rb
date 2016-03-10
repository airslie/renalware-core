require_dependency "renalware/letters"

module Renalware
  module Letters
    class DescriptionsController < ActionController::Base
      def search
        query = Letters::Descriptions::SearchQuery.new(term: params[:term])
        render json: query.call.to_json
      end
    end
  end
end