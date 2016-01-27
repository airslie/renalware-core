begin
  require "database_cleaner"
  require "database_cleaner/cucumber"

  # TODO: NJH add comment why this here
  # exceptions = %w(
  #   bag_types
  #   episode_types
  #   fluid_description
  #   organism_codes
  #   roles
  #   transplants_registration_status_descriptions
  # )

  exceptions = %w(
    drugs
    drug_types
    drug_types_drugs
    edta_codes
    ethnicities
    event_types
    hospital_centres
    medication_routes
    modality_descriptions
    modality_reasons
    organism_codes
    prd_descriptions
    transplant_registration_status_descriptions
  )

  DatabaseCleaner.strategy = :truncation, { except: exceptions }
  Cucumber::Rails::Database.javascript_strategy = :truncation, { except: exceptions }
  DatabaseCleaner.clean_with(:truncation, { except: exceptions })

rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) to use it."
end
