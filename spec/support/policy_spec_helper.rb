# frozen_string_literal: true

module PolicySpecHelper
  def user_double_with_role(role)
    instance_double(Renalware::User).tap do |user|
      allow(user).to receive_messages(has_role?: false, roles: [role], role_names: [role.to_s])
      allow(user).to receive(:has_role?).with(role).and_return(true)
    end
  end
end
