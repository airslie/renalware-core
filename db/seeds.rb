# frozen_string_literal: true

require "csv"
require_relative "./seeds/seeds_helper"

PaperTrail.enabled = false

# Seed the database with data common to all installations.
# Site specific data should be seeded from the host application.
require_relative "./seeds/default/seeds"

SeedStep.seed_steps.each do |klass|
  log klass.to_s.demodulize.titleize do
    klass.new.call
  end
end
