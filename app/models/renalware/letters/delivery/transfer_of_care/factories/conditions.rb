# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Factories::Conditions
      include Concerns::Construction
      include Concerns::Helpers

      def call
        # same approach as Medications builder
        []
      end
    end
  end
end
