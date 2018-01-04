require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class EmailLetterToGP
        def self.call(_letter, _gp)
          # noop
        end
      end
    end
  end
end
