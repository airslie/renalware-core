begin
  require "database_cleaner"
  require "database_cleaner/cucumber"

  exceptions = %w(
    access_types
    access_sites
    access_plans
    bag_types
    clinics
    drugs
    drug_types
    drug_types_drugs
    edta_codes
    episode_types
    ethnicities
    event_types
    fluid_description
    hospital_centres
    hospital_units
    letter_letterheads
    medication_routes
    modality_descriptions
    modality_reasons
    organism_codes
    pathology_observation_descriptions
    pathology_request_descriptions
    prd_descriptions
    roles
    transplant_registration_status_descriptions
    users
  )

  DatabaseCleaner.strategy = :truncation, { except: exceptions }
  Cucumber::Rails::Database.javascript_strategy = :truncation, { except: exceptions }
  DatabaseCleaner.clean_with(:truncation, { except: exceptions })

rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) to use it."
end
