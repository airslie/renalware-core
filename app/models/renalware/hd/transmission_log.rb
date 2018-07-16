# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    # Tracks the import of incoming HD Session data from an integrated dialysis provider
    # and the outgoing data back to that provider, for example HL7 messages.
    class TransmissionLog < ApplicationRecord
      belongs_to :hd_provider_unit, class_name: "ProviderUnit"
      validates :direction, presence: true
      validates :format, presence: true

      def self.policy_class
        BasePolicy
      end
    end
  end
end
