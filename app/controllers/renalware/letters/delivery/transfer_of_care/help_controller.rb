# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class HelpController < BaseController
      def show
        authorize Transmission, :show?
      end
    end
  end
end
