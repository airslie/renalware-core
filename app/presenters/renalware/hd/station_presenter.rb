# frozen_string_literal: true

module Renalware
  module HD
    class StationPresenter < DumbDelegator
      def name
        super.presence || "Unnamed Station"
      end

      def css
        return if location.blank?

        "background-color: #{location&.colour}"
      end

      def self.policy_class = StationPolicy
    end
  end
end
