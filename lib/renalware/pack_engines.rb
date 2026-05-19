# frozen_string_literal: true

require "yaml"

# Load packaged feature engines under /packs so their routes and initializers are available.
module Renalware
  module PackEngines
    module_function

    def load!
      loadable_pack_roots.each do |pack_root|
        Dir[File.join(pack_root, "lib/**/engine.rb")].each { |file| require file }
      end
    end

    def loadable_pack_roots
      Dir[File.join(packs_root, "*")]
        .select { |pack_root| File.directory?(pack_root) }
        .select { |pack_root| load_pack?(pack_root) }
    end

    def seed_file_paths
      loadable_pack_roots
        .map { |pack_root| File.join(pack_root, "db", "seeds.rb") }
        .select { |seed_file| File.exist?(seed_file) }
    end

    def packs_root
      File.expand_path("../../packs", __dir__)
    end

    def load_pack?(pack_root)
      metadata = pack_metadata(pack_root)
      return true unless metadata["optional"]

      Renalware::Extensions.enabled?(metadata.fetch("extension_name", File.basename(pack_root)))
    end

    def pack_metadata(pack_root)
      metadata_yml = File.join(pack_root, "renalware.yml")
      return {} unless File.exist?(metadata_yml)

      YAML.safe_load_file(metadata_yml) || {}
    end
  end
end
