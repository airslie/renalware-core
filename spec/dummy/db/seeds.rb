# frozen_string_literal: true

require "csv"
require Renalware::Engine.root.join("db", "seeds", "seeds_helper")

module Renalware

  # TODO: Need to refactor seedhelper so we get a #log method here

  # log "Seeding Database"
  puts "Seeding Database"

  ms = Benchmark.ms do

    # Load default Renalware Seeds
    Renalware::Engine.load_seed

    # Load seeds specific to this hospital/site (in this case the Dummy app)
    require_relative "./seeds/seeds.rb"
  end

  # log "Database seeding completed in #{ms / 1000}s"
  puts "Database seeding completed in #{ms / 1000}s"
end
