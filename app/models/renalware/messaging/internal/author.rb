# frozen_string_literal: true

module Renalware
  module Messaging
    # TODO: Document the Internal module
    module Internal
      class Author < ActiveType::Record[Renalware::User]
        has_many :messages, dependent: :destroy, foreign_key: :author_id
      end
    end
  end
end
