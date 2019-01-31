# frozen_string_literal: true

require "benchmark"

namespace :db do
  desc "Refreshes all materialized views e.g. audits. May take a while so only run overnight."
  task refresh_all_materialized_views: :environment do
    ms = Benchmark.ms do
      ActiveRecord::Base.connection.execute("SELECT refresh_all_matierialized_views();")
    end
    puts "Refreshing materialized views took #{ms}"
  end

  namespace :demo do
    desc "Loads demo seed data from the renalware-core gem"
    task seed: :environment do
      if Rails.env.development? || ENV["ALLOW_DEMO_SEEDS"] == "1"
        require Renalware::Engine.root.join("spec/dummy/db/seeds")
      else
        puts "Task currently only possible in development environment"
      end
    end
  end
end
