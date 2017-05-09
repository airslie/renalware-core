require_dependency "renalware/problems"

module Renalware
  module Problems
    class ProblemPolicy < BasePolicy
      def sort?
        edit?
      end
    end
  end
end
