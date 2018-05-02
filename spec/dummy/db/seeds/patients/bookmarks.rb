# frozen_string_literal: true

module Renalware
  log "Adding Bookmarks" do
    roger_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    jessica_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Jessica")
    francois_rabbit = Patient.find_by(family_name: "RABBIT", given_name: "François")
    current_bookmarks = Patients::Bookmark.all.select(:user_id, :patient_id)
    new_bookmarks = []

    Patient.transaction do
      [roger_rabbit, jessica_rabbit, francois_rabbit].each do |patient|
        User.pluck(:id).each do |user_id|
          next if current_bookmarks.find do |bookmark|
            bookmark.patient_id = patient.id && bookmark.user_id = user_id
          end
          new_bookmarks << Patients::Bookmark.new(user_id: user_id, patient_id: patient.id)
        end
      end
    end
    Patients::Bookmark.import!(new_bookmarks)
  end
end
