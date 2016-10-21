require "document/base"

module Renalware
  module HD
    class Session::Open < Session
      include Document::Base
      has_document class_name: "Renalware::HD::SessionDocument"

      def self.policy_class
        OpenSessionPolicy
      end
    end
  end
end
