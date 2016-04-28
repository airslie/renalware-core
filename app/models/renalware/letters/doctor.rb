require_dependency "renalware/letters"

module Renalware
  module Letters
    class Doctor < ActiveType::Record[Renalware::Doctor]
      include ActsAsLetterRecipient
    end
  end
end
