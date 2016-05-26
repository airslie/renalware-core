require "rails_helper"

module Renalware
  describe User do
    describe ".find_system_user" do
      let!(:system_user) { create(:user, username: User::SYSTEM_USERNAME) }

      it "finds the system user" do
        expect(User.find_system_user).to eq(system_user)
      end
    end
  end
end
