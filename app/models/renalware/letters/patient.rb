require_dependency "renalware/letters"

module Renalware
  module Letters
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :letters
    end
  end
end
