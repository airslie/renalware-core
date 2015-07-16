module LetterTypes
  extend ActiveSupport::Concern

  included do
    class_eval do
      LETTER_TYPES = [:clinic, :death, :discharge, :simple]

      # Create instance methods from letter types eg. 'clinic?', 'death?'
      LETTER_TYPES.each do |t|
        define_method(:"#{t}?") { letter_type == t.to_s }
      end
    end
  end
end
