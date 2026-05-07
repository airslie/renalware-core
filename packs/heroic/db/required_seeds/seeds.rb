# frozen_string_literal: true

require "engineer/database/seed_helper"

module Renalware::Heroic
  extend Engineer::Database::SeedHelper

  log_section "Seeding default required renalware-heroic data"

  require_relative "./events/seeds.rb"
  require_relative "./clinics/clinics.rb"
  require_relative "./bio_bank/sample_types.rb"
  require_relative "./reports/definitions.rb"
end
