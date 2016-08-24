require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::PendingReview < Letter
      def self.policy_class
        PendingReviewLetterPolicy
      end

      def revise(params)
        self.attributes = params
      end

      def reject(by:)
        becomes!(Draft).tap { |letter| letter.by = by }
      end

      def archive(by:, presenter: default_presenter)
        becomes!(Archived).tap do |letter|
          letter.by = by
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
