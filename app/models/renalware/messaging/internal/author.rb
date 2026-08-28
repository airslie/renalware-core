module Renalware
  module Messaging
    # TODO: Document the Internal module
    module Internal
      class Author < Renalware::User
        # rubocop:disable-next Rails/RedundantForeignKey
        has_many :messages, dependent: :destroy, foreign_key: :author_id

        def self.model_name = ActiveModel::Name.new(self, nil, "User")
      end
    end
  end
end
