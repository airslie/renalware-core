require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @typists = Letters.cast_typist(user)
        @author = Letters.cast_author(user)
      end

      def draft_letters
        @typists.letters.draft
      end

      def letters_pending_review
        @author.letters.pending_review
      end
    end
  end
end
