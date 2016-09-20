module Renalware
  log "Adding Modalities for Roger RABBIT"

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  file_path = File.join(File.dirname(__FILE__), 'rabbit_modalities.csv')

  CSV.foreach(file_path, headers: true) do |row|
    Modalities::Modality.find_or_create_by!(
      patient_id: rabbit.to_param,
      description_id: row['description_id'],
      reason_id: row['reason_id']) do |mod|
        mod.modal_change_type   = row['modal_change_type']
        mod.started_on          = row['started_on']
        mod.ended_on            = row['ended_on']
      end
  end
end
