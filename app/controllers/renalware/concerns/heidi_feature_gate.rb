require "active_support/concern"

module Renalware
  module Concerns
    module HeidiFeatureGate
      extend ActiveSupport::Concern

      included do
        before_action :require_heidi_enabled
      end

      private

      def require_heidi_enabled
        head :not_found unless Renalware.config.heidi_enabled
      end
    end
  end
end
