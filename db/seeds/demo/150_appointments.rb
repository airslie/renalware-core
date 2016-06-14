module Renalware
  log "--------------------Adding Appointments --------------------"

  file_path = File.join(demo_path, "appointments.csv")

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    starts_at = Time.now + rand(10).days
    starts_at_array = row["starts_at"].split(":")

    Clinics::Appointment.find_or_create_by!(
      starts_at: starts_at.change({ hour: starts_at_array[0], min: starts_at_array[1] }),
      patient: Clinics::Patient.find_by(local_patient_id: row["local_patient_id"]),
      user: User.find_by(username: row["username"]),
      clinic: Clinics::Clinic.find_by(name: row["clinic_name"])
    )
  end

  log "#{logcount} Appointments seeded"
end
