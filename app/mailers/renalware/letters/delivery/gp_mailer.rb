module Renalware
  module Letters
    module Delivery
      class GPMailer < ApplicationMailer
        def patient_letter(_letter, _gp)
          # noop
        end
      end
    end
  end
end
