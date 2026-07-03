# frozen_string_literal: true

module Renalware
  module Legacy
    class LettersController < BaseController
      before_action :ensure_legacy_letters_enabled

      def index
        query = Renalware::Legacy::Letters::Query.new(patient:, q: params[:q])
        pagy, letters = pagy(query.call)
        authorize letters
        render locals: { patient:, letters:, search: query.search, pagy: }
      end

      def show
        letter = Renalware::Legacy::Letter.for_patient(patient).find(params[:id])
        authorize letter
        render locals: { letter: }, layout: "renalware/layouts/legacy_letter"
      end

      private

      def ensure_legacy_letters_enabled
        return if Renalware.config.legacy_letters_enabled

        skip_authorization
        head :not_found
      end
    end
  end
end
