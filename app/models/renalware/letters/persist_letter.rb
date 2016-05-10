require_dependency "renalware/letters"

module Renalware
  module Letters
    class PersistLetter
      include Wisper::Publisher

      def self.build
        self.new.on(:persist_letter_successful) do |letter|
          AssignAutomaticCCs.build.call(letter)
        end
      end

      def call(letter)
        letter.save!
        broadcast(:persist_letter_successful, letter)
      end
    end
  end
end