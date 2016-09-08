require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @typists = Letters.cast_typist(user)
      end

      def draft_letters
        @typists.letters.draft
      end
    end
  end
end
