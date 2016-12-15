module Renalware
  log "Adding Modalities for Roger RABBIT" do

    rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    file_path = File.join(File.dirname(__FILE__), "rabbit_modalities.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Modalities::Modality.find_or_create_by!(
        patient_id: rabbit.id,
        description_id: row["description_id"],
        started_on: row["started_on"],
        ended_on: row["ended_on"],
        created_by_id: Renalware::User.first.id)
    end
  end
end
