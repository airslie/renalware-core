require "rails_helper"

module Renalware

  describe UserPolicy, type: :policy do
    let(:admin) { create(:user, :admin) }
    let(:clinician) { create(:user, :clinician) }
    let(:other_clinician) { create(:user, :clinician) }

    subject { described_class }

    permissions :update? do
      it "permits an admin user to update other users" do
        expect(subject).to permit(admin, clinician)
      end

      it "does not permit the user to update themselves" do
        expect(subject).to_not permit(admin, admin)
      end

      it "does not permit a non-admin to update another user" do
        expect(subject).to_not permit(clinician, other_clinician)
      end
    end
  end
end