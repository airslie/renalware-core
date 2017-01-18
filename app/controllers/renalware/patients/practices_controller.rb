require_dependency "renalware/patients"

module Renalware
  module Patients
    class PracticesController < BaseController

      # Search for GP Practices matching part of a name
      def search
        authorize Practice, :search?
        respond_to do |format|
          format.json do
            render json: practices_with_name_matching(term: search_term)
          end
        end
      end

      private

      def practices_with_name_matching(term:)
        return [] unless term.present?
        Practice.where("name ILIKE ?", "%#{term}%").select(:id, :name)
      end

      def search_term
        params[:q]
      end
    end
  end
end
