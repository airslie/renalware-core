# frozen_string_literal: true

require "document/base"

module Renalware
  module HD
    class Session::Open < Session
      include Document::Base
      has_document class_name: "Renalware::HD::SessionDocument"
      validates :started_at, presence: true

      def self.policy_class
        OpenSessionPolicy
      end

      def immutable?
        false
      end
    end
  end
end
