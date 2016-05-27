require "rails_helper"

module Renalware
  describe SystemUser do
    describe ".find" do
      let!(:system_user) { create(:user, username: SystemUser.username) }

      it "finds the system user" do
        expect(SystemUser.find).to eq(system_user)
      end
    end
  end
end
