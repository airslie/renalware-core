# frozen_string_literal: true

module Renalware
  module Snippets
    class User < Renalware::User
      has_many :snippets, inverse_of: :author, foreign_key: :author_id

      def self.model_name = ActiveModel::Name.new(self, nil, "User")
    end
  end
end
