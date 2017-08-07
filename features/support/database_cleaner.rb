begin
  require "database_cleaner"
  require "database_cleaner/cucumber"

  if ENV["TEST_DEPTH"] == "web"
    DatabaseCleaner.strategy = :truncation
    # , {
    #   except: %w[
    #     access_plan_types
    #     access_sites
    #     clinic_clinics
    #     death_causes
    #   ]
    # }
  else
    DatabaseCleaner.strategy = :transaction
  end
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in :test group) if you wish to use it."
end

Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end
