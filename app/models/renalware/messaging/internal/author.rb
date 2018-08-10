# frozen_string_literal: true

require_dependency "renalware/messaging"

module Renalware
  module Messaging
    # TODO: Document the Internal module
    module Internal
      class Author < ActiveType::Record[Renalware::User]
        has_many :messages, dependent: :destroy
      end
    end
  end
end
