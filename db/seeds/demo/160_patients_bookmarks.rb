module Renalware
  log "--------------------Adding Bookmarks --------------------"

  users = User.all
  roger_rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  jessica_rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Jessica')

  logcount=0
  [roger_rabbit, jessica_rabbit].each do |patient|
    users.each do |user|
      logcount += 1
      patients_user = Patients.cast_user(user)
      patients_user.bookmarks.create!(patient: patient)
    end
  end

  log "#{logcount} Bookmarks seeded"
end
