# frozen_string_literal: true

module Renalware
  module Snippets
    def self.table_name_prefix = "snippets_"
    def self.cast_user(user) = user.becomes(Snippets::User)
  end
end
