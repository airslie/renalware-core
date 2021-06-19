# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Problems
    class ProblemPolicy < BasePolicy
      def sort?
        edit?
      end

      def search?
        edit?
      end
    end
  end
end
