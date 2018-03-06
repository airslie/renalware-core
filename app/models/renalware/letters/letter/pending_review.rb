require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::PendingReview < Letter
      def self.policy_class
        PendingReviewLetterPolicy
      end

      def revise(params)
        params = LetterParamsProcessor.new(patient).call(params)
        self.attributes = params
      end

      def reject(by:)
        becomes!(Draft).tap { |letter| letter.by = by }
      end

      def sign(by:)
        build_signature(user: by, signed_at: Time.current)
        self.approved_by = by
        self.approved_at = Time.current
        self.by = by
        self
      end

      def generate_archive(by:, presenter: default_presenter)
        becomes!(Approved).tap do |letter|
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
