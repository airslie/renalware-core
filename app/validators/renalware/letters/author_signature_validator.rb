module Renalware
  module Letters
    class AuthorSignatureValidator < ActiveModel::Validator
      def validate(letter)
        return if letter.death_notification?
        if letter.author && letter.author.signature.blank?
          errors[:signature] << 'Author must have a signature'
        end
      end
    end
  end
end