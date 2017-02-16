module Renalware
  log "Adding Roles" do
    %i(super_admin admin clinician read_only).each do |role|
      hidden = (role == :super_admin)
      Role.find_or_create_by!(name: role, hidden: hidden)
    end
  end
end
