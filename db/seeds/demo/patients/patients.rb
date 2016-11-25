module Renalware
  log "Adding Patients" do

    file_path = Rails.root.join(File.dirname(__FILE__), "patients.csv")
    system_user = SystemUser.find
    demo_nhsno = 1234567890

    # if Patient.count == 0
    #     # Use #import! which is 4 times faster
    #     rows = CSV.read(file_path, headers: true)

    #     objects = rows[1..-1].map do |row|
    #       demo_nhsno += 1
    #       local_patient_id = row["local_patient_id"]
    #       Patient.new(
    #           local_patient_id: local_patient_id,
    #           family_name: row["family_name"],
    #           given_name: row["given_name"],
    #           sex: row["sex"],
    #           born_on: row["born_on"],
    #           nhs_number: demo_nhsno,
    #           created_at: row["created_at"],
    #           by: system_user
    #         )
    #     end

    #     Patient.import! objects, validate: true
    # else
      CSV.foreach(file_path, headers: true) do |row|
        local_patient_id = row["local_patient_id"]
        demo_nhsno += 1

        Patient.find_or_create_by!(local_patient_id: local_patient_id) do |patient|
          patient.family_name = row["family_name"]
          patient.given_name = row["given_name"]
          patient.sex = row["sex"]
          patient.born_on = row["born_on"]
          patient.nhs_number = demo_nhsno
          patient.created_at = row["created_at"]
          patient.by = system_user
        end
      end
    # end
  end
end
