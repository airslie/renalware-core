# frozen_string_literal: true

module MigrationHelper
  def within_renalware_schema
    reversible do |direction|
      direction.up { connection.execute("SET SEARCH_PATH=renalware,public;") }
      direction.down { connection.execute("SET SEARCH_PATH=renalware,public;") }
    end
    yield if block_given?
  end
end
