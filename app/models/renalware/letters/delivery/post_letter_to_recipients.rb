require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class PostLetterToRecipients
        def self.call(_letter, _recipients)
          # noop
        end
      end
    end
  end
end
