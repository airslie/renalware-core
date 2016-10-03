require_dependency "renalware/letters"

module Renalware
  module Letters
    class ApproveLetter
      class << self
        alias_method :build, :new
      end

      def initialize(letter)
        @letter = letter
      end

      def call(by:)
        Letter.transaction do
          sign(by: by)
          archive_content(by: by)
          archive_recipients
        end
      end

      def sign(by:)
        # Needs to be saved before changing the STI type
        # (signature would be lost otherwise)
        @letter.sign(by: by).save!
      end

      def archive_content(by:)
        @letter.generate_archive(by: by).save!
      end

      def archive_recipients
        @letter.recipients.each { |r| r.archive! }
      end
    end
  end
end

