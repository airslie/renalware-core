require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::PendingReview < Letter
      def self.policy_class
        PendingReviewLetterPolicy
      end

      def sign(by:)
        build_signature(user: by, signed_at: Time.now)
      end

      def archive(by:, presenter_class: LetterPresenterFactory)
        content = generate_content_to_archive(presenter_class)

        becomes!(Archived).tap do |letter|
          letter.by = by
          letter.build_archive(by: by, content: content)
        end
      end

      def generate_content_to_archive(presenter_class)
        presenter_class.new(self).content
      end
    end
  end
end
