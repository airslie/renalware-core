# frozen_string_literal: true

module Renalware
  module ScenicViewPaths
    def full_path
      configured_view_paths.each do |path|
        candidate = Pathname(path).join(filename)
        return candidate if candidate.exist?
      end

      super
    end

    private

    def configured_view_paths
      Rails.application.config.paths["db/views"].to_a
    end
  end
end

Scenic::Definition.prepend(Renalware::ScenicViewPaths)
