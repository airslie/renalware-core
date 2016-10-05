require_dependency "renalware/letters/letter"

module Renalware
  module Letters
    class Letter::Draft < Letter
      def self.policy_class
        DraftLetterPolicy
      end

      def revise(params)
        params = LetterParamsProcessor.new(patient).call(params)
        self.attributes = params
      end

      def submit(by:)
        becomes!(PendingReview).tap { |letter| letter.by = by }
      end
    end
  end
end
