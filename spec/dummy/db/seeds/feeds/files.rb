module Renalware
  log "Adding dummy file feeds for display on the admin file feeds page" do
    user_id = Renalware::User.first.id
    Feeds::File.create!(
      file_type: Feeds::FileType.find_by!(name: :practices),
      location: "/some/where.zip",
      created_by_id: user_id,
      updated_by_id: user_id,
      status: :success
    )
  end
end
