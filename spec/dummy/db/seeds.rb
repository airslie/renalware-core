# frozen_string_literal: true

require "csv"
require Renalware::Engine.root.join("db", "seeds", "seeds_helper")

include SeedsHelper

module Renalware
  log "Seeding Database"

  ms = Benchmark.ms do
    # Load default Renalware Seeds
    Renalware::Engine.load_seed

    # Load seeds specific to this hospital/site (in this case the Dummy app)
    require_relative "./seeds/seeds"
  end

  log "Database seeding completed in #{ms / 1000}s"
end
