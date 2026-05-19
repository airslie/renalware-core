require "csv"
require_relative "seeds/seeds_helper"

PaperTrail.enabled = false

# TODO: Move this
include SeedsHelper # rubocop:disable Style/MixinUsage

Rails.logger = Logger.new($stdout)
Rails.benchmark "Seeding Database" do
  require_relative "seeds/default/seeds"
  require_relative "seeds/demo/seeds"

  Renalware::PackEngines.seed_file_paths.each do |seed_file|
    load seed_file
  end
end
