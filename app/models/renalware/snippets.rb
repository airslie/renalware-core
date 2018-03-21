# frozen_string_literal: true

module Renalware
  module Snippets
    def self.table_name_prefix
      "snippets_"
    end

    def self.cast_user(user)
      ActiveType.cast(user, ::Renalware::Snippets::User)
    end
  end
end
