require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::PendingReview < Letter
      def self.policy_class
        PendingReviewLetterPolicy
      end

      def archive(by:, presenter: default_presenter)
        becomes!(Archived).tap do |letter|
          letter.by = by
          letter.signed_at = Time.now
          letter.build_archive(by: by, content: presenter.content)
        end
      end

      private

      def default_presenter
        LetterPresenterFactory.new(self)
      end
    end
  end
end
