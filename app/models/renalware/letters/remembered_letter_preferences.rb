require_dependency "renalware/letters"

module Renalware
  module Letters
    class RememberedLetterPreferences < RememberedPreferences
      SESSION_KEY = :letter_preferences
      ATTRIBUTES_TO_REMEMBER = %i(letterhead_id description author_id issued_on).freeze
    end
  end
end
