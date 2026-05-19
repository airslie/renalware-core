# frozen_string_literal: true

require "rails_helper"

RSpec.describe Renalware::PackEngines do
  around do |example|
    original_extensions = ENV.fetch("RENALWARE_EXTENSIONS", nil)

    example.run
  ensure
    if original_extensions.nil?
      ENV.delete("RENALWARE_EXTENSIONS")
    else
      ENV["RENALWARE_EXTENSIONS"] = original_extensions
    end
  end

  describe ".load_pack?" do
    it "loads packs without Renalware metadata" do
      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
        expect(described_class.load_pack?(dir)).to be(true)
      end
    end

    it "skips optional packs when their extension is disabled" do
      ENV.delete("RENALWARE_EXTENSIONS")

      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
        File.write(File.join(dir, "renalware.yml"), <<~YAML)
          optional: true
          extension_name: heroic
        YAML

        expect(described_class.load_pack?(dir)).to be(false)
      end
    end

    it "loads optional packs when their extension is enabled" do
      ENV["RENALWARE_EXTENSIONS"] = "heroic"

      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
        File.write(File.join(dir, "renalware.yml"), <<~YAML)
          optional: true
          extension_name: heroic
        YAML

        expect(described_class.load_pack?(dir)).to be(true)
      end
    end
  end

  describe ".seed_file_paths" do
    it "returns seed files for loadable packs" do
      ENV["RENALWARE_EXTENSIONS"] = "heroic"

      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |root|
        pack_root = File.join(root, "heroic")
        FileUtils.mkdir_p(File.join(pack_root, "db"))
        File.write(File.join(pack_root, "renalware.yml"), <<~YAML)
          optional: true
          extension_name: heroic
        YAML
        seed_file = File.join(pack_root, "db", "seeds.rb")
        File.write(seed_file, "# seeds")

        allow(described_class).to receive(:packs_root).and_return(root)

        expect(described_class.seed_file_paths).to contain_exactly(seed_file)
      end
    end

    it "does not return seed files for disabled optional packs" do
      ENV.delete("RENALWARE_EXTENSIONS")

      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |root|
        pack_root = File.join(root, "heroic")
        FileUtils.mkdir_p(File.join(pack_root, "db"))
        File.write(File.join(pack_root, "renalware.yml"), <<~YAML)
          optional: true
          extension_name: heroic
        YAML
        File.write(File.join(pack_root, "db", "seeds.rb"), "# seeds")

        allow(described_class).to receive(:packs_root).and_return(root)

        expect(described_class.seed_file_paths).to be_empty
      end
    end
  end
end
