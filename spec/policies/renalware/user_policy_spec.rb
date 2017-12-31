require "rails_helper"

module Renalware
  describe UserPolicy, type: :policy do
    subject(:policy) { described_class }

    let(:admin) { create(:user, :admin) }
    let(:clinician) { create(:user, :clinical) }
    let(:other_clinician) { create(:user, :clinical) }

    permissions :update? do
      it "permits an admin user to update other users" do
        expect(policy).to permit(admin, clinician)
      end

      it "does not permit the user to update themselves" do
        expect(policy).not_to permit(admin, admin)
      end

      it "does not permit a non-admin to update another user" do
        expect(policy).not_to permit(clinician, other_clinician)
      end
    end
  end
end
