# frozen_string_literal: true

module CoreExtensions
  module ActiveRecord
    module MigrationHelpers
      # Can be called from a migration to load in a function from a sql file
      # at e.g. db/functions/my_function_v01.sql
      #
      # Example usage:
      #  load_function("my_function_v01.sql")
      #
      def load_function(filename)
        load_sql_file(DatabaseObjectPaths.functions, filename)
      end

      # Can be called from a migration to load in a trigger from a sql file
      # at e.g. db/functions/my_trigger_v01.sql
      #
      # Example usage:
      #  load_trigger("my_trigger_v01.sql")
      #
      def load_trigger(filename)
        load_sql_file(DatabaseObjectPaths.triggers, filename)
      end

      def load_sql_file(paths, filename)
        found = false
        paths.each do |path|
          file_path = path.join(filename)
          if File.exist?(file_path)
            connection.execute(File.read(file_path))
            found = true
          end
        end
        unless found
          raise "Cannot file #{filename} in #{paths.join(', ')}"
        end
      end

      # Make sure to look in the host Rails app as well as in the engine
      class DatabaseObjectPaths
        class << self
          def triggers
            [
              Rails.root.join("db", "triggers"),
              Renalware::Engine.root.join("db", "triggers")
            ]
          end

          def functions
            [
              Rails.root.join("db", "functions"),
              Renalware::Engine.root.join("db", "functions")
            ]
          end
        end
      end
    end
  end
end

ActiveRecord::Migration[5.1].send(:prepend, CoreExtensions::ActiveRecord::MigrationHelpers)
