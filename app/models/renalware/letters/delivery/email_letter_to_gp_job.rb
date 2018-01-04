require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class EmailLetterToGPJob < ApplicationJob
        def perform(_letter, _gp); end
      end
    end
  end
end
