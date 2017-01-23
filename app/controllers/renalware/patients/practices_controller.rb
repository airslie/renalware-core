require_dependency "renalware/patients"

module Renalware
  module Patients
    class PracticesController < BaseController

      # Search for GP Practices matching part of a name
      def search
        authorize Practice, :search?
        respond_to do |format|
          format.json do
            render json: practices_matching_search_term
          end
        end
      end

      private

      def practices_matching_search_term
        PracticeSearchQuery.new(search_term: params[:q]).call
      end
    end
  end
end
