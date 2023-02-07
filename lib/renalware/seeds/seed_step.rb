# frozen_string_literal: true

# Collects the seed classes
# See db/seeds/default/system/view_metadata.rb for a usage example
module SeedStep
  mattr_accessor :seed_steps, default: []

  def self.included(klass)
    seed_steps << klass
  end
end
