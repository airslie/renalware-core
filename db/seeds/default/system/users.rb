module Renalware
  log "Adding System User"

  Renalware::User.find_or_create_by!(given_name: "System", family_name: "User") do |user|
    user.username = Renalware::SystemUser.username
    user.password = SecureRandom.hex(32)
    user.email = "systemuser@renalware.net"
    user.approved = true
    user.signature = "System User"
  end
end
