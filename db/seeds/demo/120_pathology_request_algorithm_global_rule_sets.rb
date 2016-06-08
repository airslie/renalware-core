module Renalware
  log '--------------------Adding Pathology Request Algorithm Global Rule Sets --------------------'

  file_path = File.join(demo_path, 'pathology_request_algorithm_global_rule_sets.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1

    clinic = ::Renalware::Clinics::Clinic.find_by(name: row["clinic"])
    Pathology::RequestAlgorithm::GlobalRuleSet.find_or_create_by!(
      id: row["id"],
      clinic: clinic,
      request_description_id: row["request_description_id"],
      frequency_type: row["frequency_type"]
    )
  end

  log "#{logcount} Global Rule Sets seeded"
end
