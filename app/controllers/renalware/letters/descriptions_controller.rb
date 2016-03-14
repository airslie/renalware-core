require_dependency "renalware/letters"

module Renalware
  module Letters
    class DescriptionsController < ActionController::Base
      def search
        query = Letters::Descriptions::SearchQuery.new(term: params[:term])
        render json: DescriptionAutocompleteResponse.to_json(query.call)
      end

      class DescriptionAutocompleteResponse
        def self.to_json(collection)
          collection.map do |item|
            { id: item.id, label: item.text }
          end.to_json
        end
      end
    end
  end
end