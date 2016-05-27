require_dependency "renalware"
require_dependency "renalware/letters/author"

module Renalware
  module Letters
    def self.table_name_prefix
      "letter_"
    end

    def self.cast_author(user)
      ActiveType.cast(user, Author)
    end
  end
end
