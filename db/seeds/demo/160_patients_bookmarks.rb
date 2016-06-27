module Renalware
  log "--------------------Adding Bookmarks --------------------"

  file_path = File.join(demo_path, "patients_bookmarks.csv")

  logcount=0
  roger_rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  User.all.each do |user|
    logcount += 1

    patients_user = Patients.cast_user(user)
    patients_user.bookmarks.create!(patient: roger_rabbit)
  end

  log "#{logcount} Bookmarks seeded"
end
