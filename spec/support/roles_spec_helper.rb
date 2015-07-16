module RolesSpecHelper
  def define_roles
    %i(super_admin admin clinician read_only).each do |name|
      Role.find_or_create_by!(name: name)
    end
  end
end
