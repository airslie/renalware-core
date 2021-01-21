# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class PracticesController < BaseController
      skip_after_action :verify_policy_scoped

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
        PracticeSearchQuery.new(search_term: params[:q])
          .call
          .map { |practice| format_practice_into_hash_for_json(practice) }
      end

      def null_address
        Address.new
      end

      def format_practice_into_hash_for_json(practice)
        address = practice.address || null_address
        {
          id: practice.id,
          name: "#{practice.name} (#{practice.code})",
          address: [
            address.street_1,
            address.town,
            address.county,
            address.postcode
          ].reject(&:blank?).join(", ")
        }
      end
    end
  end
end
