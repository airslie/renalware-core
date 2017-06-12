module Renalware
  log "Adding Bookmarks" do
    users = User.all
    roger_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    jessica_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Jessica")
    francois_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "François")

    Patient.transaction do
      [roger_rabbit, jessica_rabbit, francois_rabbit].each do |patient|
        users.each do |user|
          patients_user = Patients.cast_user(user)
          patients_user.bookmarks.find_or_create_by!(patient: patient)
        end
      end
    end
  end
end
