module Renalware
  log "Adding Roles" do
    Role::ROLES.each do |role|
      hidden = (role == :super_admin)
      Role.find_or_create_by!(name: role, hidden: hidden)
    end
  end
end
