# frozen_string_literal: true

module Renalware
  module HD
    class StationPresenter < SimpleDelegator
      def name
        super.presence || "Unnamed Station"
      end

      def css
        return if location.blank?

        "background-color: #{location&.colour}"
      end
    end
  end
end
