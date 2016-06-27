module Renalware
  log "--------------------Adding Bookmarks --------------------"

  logcount=0
  roger_rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  User.all.each do |user|
    logcount += 1

    patients_user = Patients.cast_user(user)
    patients_user.bookmarks.create!(patient: roger_rabbit)
  end

  log "#{logcount} Roger RABBIT Bookmarks seeded"
end
