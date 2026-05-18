# frozen_string_literal: true

require "scenic"
require "paper_trail"
require "paranoia"
require "renalware"
require_relative "configuration"

module Renalware
  module Heroic
    def self.table_name_prefix = "renalware_heroic."

    class Engine < ::Rails::Engine
      isolate_namespace Renalware::Heroic

      initializer :heroic_assets do |app|
        app.config.assets.precompile += %w(renalware/heroic.css)
      end

      initializer :heroic_database_paths, after: :resolve_scenic_paths do |app|
        add_path = lambda do |logical_path, path|
          paths = app.config.paths[logical_path]

          if paths
            paths << path unless paths.to_a.include?(path)
          else
            app.config.paths.add(logical_path, with: path)
          end
        end

        migration_path = root.join("db/migrate").to_s
        add_path.call("db/migrate", migration_path)
        ActiveRecord::Migrator.migrations_paths << migration_path unless
          ActiveRecord::Migrator.migrations_paths.include?(migration_path)

        add_path.call("db/views", root.join("db/views").to_s)
      end
    end
  end
end
