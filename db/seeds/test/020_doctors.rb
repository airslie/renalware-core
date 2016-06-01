module Renalware
  log "--------------------Adding Doctors --------------------"

  file_path = File.join(test_path, "doctors.csv")

  logcount=0

  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    practice = Practice.find_by(code: row["practice_code"])

    Doctor.find_or_create_by!(
      given_name: row["given_name"],
      family_name: row["family_name"],
      email: row["email"],
      code: row["code"],
      practitioner_type: row["practitioner_type"],
      address_id: practice.address.id
    )
  end

  log "#{logcount} Doctors seeded"
end
