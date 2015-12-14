begin
  require "database_cleaner"
  require "database_cleaner/cucumber"

  # TODO: NJH add comment why this here
  # exceptions = %w(
  #   bag_types
  #   edta_codes
  #   episode_types
  #   event_types
  #   etchnicities
  #   fluid_description
  #   modality_codes
  #   modality_reasons
  #   organism_codes
  #   prd_descriptions
  #   roles
  #   transplants_registration_status_descriptions
  # )

  exceptions = %w(
    drugs
    drug_types
    drug_types_drugs
    medication_routes
    organism_codes
    transplants_registration_status_descriptions
  )

  DatabaseCleaner.strategy = :truncation, { except: exceptions }
  Cucumber::Rails::Database.javascript_strategy = :truncation, { except: exceptions }
  DatabaseCleaner.clean_with(:truncation, { except: exceptions })

rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) to use it."
end
