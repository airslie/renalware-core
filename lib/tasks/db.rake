require "benchmark"

namespace :db do
  desc "Refreshes all materialized views e.g. audits. May take a while so only run overnight."
  task refresh_all_materialized_views: :environment do
    ms = Benchmark.ms do
      ActiveRecord::Base.connection.execute("SELECT refresh_all_matierialized_views();")
    end
    puts "Refreshing materialized views took #{ms}"
  end
end
