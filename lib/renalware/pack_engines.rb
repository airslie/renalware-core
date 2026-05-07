# frozen_string_literal: true

require "yaml"

# Load packaged feature engines under /packs so their routes and initializers are available.
module Renalware
  module PackEngines
    module_function

    def load!
      Dir[File.join(packs_root, "*")].each do |pack_root|
        next unless File.directory?(pack_root)
        next unless load_pack?(pack_root)

        Dir[File.join(pack_root, "lib/**/engine.rb")].each { |file| require file }
      end
    end

    def packs_root
      File.expand_path("../../packs", __dir__)
    end

    def load_pack?(pack_root)
      metadata = package_metadata(pack_root)
      return true unless metadata["optional"]

      Renalware::Extensions.enabled?(metadata.fetch("extension_name", File.basename(pack_root)))
    end

    def package_metadata(pack_root)
      package_yml = File.join(pack_root, "package.yml")
      return {} unless File.exist?(package_yml)

      YAML.safe_load_file(package_yml) || {}
    end
  end
end
