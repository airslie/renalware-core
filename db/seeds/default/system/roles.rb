module Renalware
  log "Adding Roles" do
    Role::ROLES.each do |role|
      hidden = ([:super_admin, :devops].include?(role))
      Role.find_or_create_by!(name: role, hidden: hidden)
    end
  end
end
