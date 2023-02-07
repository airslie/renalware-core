# frozen_string_literal: true

module Renalware
  module Snippets
    def self.table_name_prefix = "snippets_"

    def self.cast_user(user)
      ActiveType.cast(
        user,
        ::Renalware::Snippets::User,
        force: Renalware.config.force_cast_active_types
      )
    end
  end
end
