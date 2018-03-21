# frozen_string_literal: true

module Renalware
  module HD
    class StationPolicy < BasePolicy
      def sort?
        edit?
      end
    end
  end
end
