module Renalware

  log "Adding Primary Care Physicians\n" do
    sample_status = "SAMPLE ONLY"
    file_path = File.join(File.dirname(__FILE__), "primary_care_physicians_sample.csv")
    #"id","practice_code","gp_code","name","practice_id"

    CSV.foreach(file_path, headers: true) do |row|
      practice_id = row["practice_id"].to_i

      Patients::PrimaryCarePhysician.find_or_create_by!(code: row["gp_code"]) do |doc|
        doc.name = row["name"]
        doc.practitioner_type = "GP"
        doc.practice_ids = [practice_id]
      end
    end
    log_count = Patients::PrimaryCarePhysician.count
    log "#{log_count} NHS primary care physicians imported #{sample_status}", type: :sub
  end
end
