# frozen_string_literal: true

module RolesSpecHelper
  def define_roles
    Renalware::Role::ROLES.each do |name|
      Renalware::Role.find_or_create_by!(name: name)
    end
  end

  def user_with_role(role)
    instance_double(Renalware::User).tap do |user|
      allow(user).to receive(:has_role?).and_return(false)
      allow(user).to receive(:has_role?).with(role).and_return(true)
    end
  end
end
