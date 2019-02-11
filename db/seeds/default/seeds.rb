# frozen_string_literal: true

require "engineer/database/seed_helper"

module Renalware
  extend Engineer::Database::SeedHelper
  log_section "Seeding default renalware-core data"
end

require_relative "./system/seeds"
require_relative "./ukrdc/seeds"
require_relative "./reporting/audits"
require_relative "./feeds/seeds"
require_relative "./deaths/seeds"
require_relative "./accesses/seeds"
require_relative "./clinics/seeds"
require_relative "./events/seeds"
require_relative "./hd/seeds"
require_relative "./letters/seeds"
require_relative "./medications/seeds"
require_relative "./modalities/seeds"
require_relative "./pathology/seeds"
require_relative "./patients/seeds"
require_relative "./practices/seeds"
require_relative "./pd/seeds"
require_relative "./renal/seeds"
require_relative "./transplants/seeds"
require_relative "./virology/seeds"
