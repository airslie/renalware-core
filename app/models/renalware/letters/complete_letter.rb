require_dependency "renalware/letters"

module Renalware
  module Letters
    class CompleteLetter
      class << self
        alias_method :build, :new
      end

      def initialize(letter)
        @letter = letter
      end

      def call(by:)
        @letter.complete(by: by).save!
      end
    end
  end
end
