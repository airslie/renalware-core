# frozen_string_literal: true

require "benchmark"

namespace :heroic do
  namespace :db do
    desc "Loads demo seeds from renalware-core then adds renalware-heroic demo seeds"
    task seed: :environment do
      if Rails.env.development? || ENV["ALLOW_DEMO_SEEDS"].present?
        require Renalware::Heroic::Engine.root.join("db", "seeds")
      else
        puts "Task currently only possible in development environment or with ALLOW_DEMO_SEEDS"
      end
    end
  end
end
