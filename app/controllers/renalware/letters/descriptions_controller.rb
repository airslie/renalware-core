# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class DescriptionsController < ApplicationController
      def search
        query = Letters::Descriptions::SearchQuery.new(params[:term])
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
