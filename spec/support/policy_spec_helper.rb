# frozen_string_literal: true

module PolicySpecHelper
  def user_double_with_role(role)
    instance_double(Renalware::User).tap do |user|
      allow(user).to receive(:has_role?).and_return(false)
      allow(user).to receive(:has_role?).with(role).and_return(true)
      allow(user).to receive(:roles).and_return([role])
      allow(user).to receive(:role_names).and_return([role.to_s])
    end
  end
end
