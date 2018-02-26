require_dependency "renalware/letters"

module Renalware
  module Letters
    class Author < ActiveType::Record[Renalware::User]
      has_many :letters
    end
  end
end
