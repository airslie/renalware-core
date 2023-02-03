# frozen_string_literal: true

module Renalware
  module Messaging
    # TODO: Document the Internal module
    module Internal
      class Author < ActiveType::Record[Renalware::User]
        # rubocop:disable Rails/RedundantForeignKey
        has_many :messages, dependent: :destroy, foreign_key: :author_id
        # rubocop:enable Rails/RedundantForeignKey
      end
    end
  end
end
