# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare::Sections
    module NotImplemented
      def render? = false

      def call
        raise NotImplementedError
      end
    end
  end
end
