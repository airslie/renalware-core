log '--------------------Adding Roles--------------------'

%i(super_admin admin clinician read_only).each do |role|
  Role.find_or_create_by!(name: role)
end
