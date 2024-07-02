# frozen_string_literal: true

# require_relative "configuration"

module Renalware
  module Snippeting
    def self.table_name_prefix = "snippets_"
    def self.cast_user(user) = user.becomes(Snippeting::User)

    class Engine < Rails::Engine
      isolate_namespace Snippeting
    end
  end
end
