# frozen_string_literal: true

require_dependency "renalware/snippets"

module Renalware
  module Snippets
    class User < ActiveType::Record[Renalware::User]
      has_many :snippets, inverse_of: :author, foreign_key: :author_id
    end
  end
end
