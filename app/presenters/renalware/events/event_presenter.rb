# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class EventPresenter < DumbDelegator
      def effective_updated_by
        return unless been_updated?

        updated_by&.full_name
      end

      def effective_updated_at
        return unless been_updated?

        updated_at&.to_date
      end

      private

      def been_updated?
        updated_at > created_at
      end
    end
  end
end
