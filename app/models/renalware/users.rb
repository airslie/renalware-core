# frozen_string_literal: true

module Renalware
  module Users
    def self.table_name_prefix
      "user_"
    end

    module Groups
      def self.table_name_prefix
        "user_group_"
      end
    end
  end
end
