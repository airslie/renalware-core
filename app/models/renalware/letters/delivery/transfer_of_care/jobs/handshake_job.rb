# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Jobs::HandshakeJob < Jobs::TransferOfCareJob
      def perform
        API::LogOperation.call(:handshake) do
          API::Client.handshake
        end
      end
    end
  end
end
