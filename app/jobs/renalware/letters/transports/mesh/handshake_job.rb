# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class HandshakeJob < ApplicationJob
      queue_as :transfer_of_care
      queue_with_priority 10

      def perform
        API::LogOperation.call(:handshake) do
          API::Client.handshake
        end
      end
    end
  end
end
