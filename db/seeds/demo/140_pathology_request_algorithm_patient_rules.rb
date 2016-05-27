module Renalware
  log '--------------------Adding Pathology Request Algorithm Patient Rules --------------------'

  file_path = File.join(demo_path, 'pathology_request_algorithm_patient_rules.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    lab = Pathology::Lab.find_by(name: row["lab"])

    Pathology::RequestAlgorithm::PatientRule.find_or_create_by!(
      lab: lab,
      test_description: row["test_description"],
      sample_number_bottles: row["sample_number_bottles"],
      sample_type: row["sample_type"],
      frequency_type: row["frequency_type"],
      patient_id: row["patient_id"],
      last_observed_at: row["last_observed_at"],
      start_date: row["start_date"],
      end_date: row["end_date"]
    )
  end

  log "#{logcount} Patient Rules seeded"
end
