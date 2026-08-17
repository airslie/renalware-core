module Renalware
  module Feeds
    class OutgoingDocumentsController < BaseController
      def index
        query = OutgoingDocument
          .includes(:created_by)
          .ransack(search_params)
        pagy, documents = pagy(query.result)
        authorize documents
        render locals: { documents: documents, pagy: pagy, query: query }
      end

      private

      def search_params
        params
          .fetch(:q, ActionController::Parameters.new)
          .permit(:state_eq, :s)
          .to_h
          .tap do |query_params|
          query_params["s"] = "created_at desc" if query_params["s"].blank?
        end
      end
    end
  end
end
