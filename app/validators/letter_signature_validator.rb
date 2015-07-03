class LetterSignatureValidator < ActiveModel::Validator

  def validate(letter)
    return if letter.death?
    unless letter.author.signature.present?
      errors[:signature] << 'Author must have a signature'
    end
  end
end
