# frozen_string_literal: true

module Renalware
  module Letters
    class RememberedLetterPreferences < RememberedPreferences
      SESSION_KEY = :letter_preferences
      ATTRIBUTES_TO_REMEMBER = %i(letterhead_id description author_id).freeze
    end
  end
end
