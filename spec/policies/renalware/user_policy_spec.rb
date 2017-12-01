require "rails_helper"

module Renalware
  describe UserPolicy, type: :policy do
    subject { described_class }

    let(:admin) { create(:user, :admin) }
    let(:clinician) { create(:user, :read_write) }
    let(:other_clinician) { create(:user, :read_write) }

    permissions :update? do
      it "permits an admin user to update other users" do
        expect(subject).to permit(admin, clinician)
      end

      it "does not permit the user to update themselves" do
        expect(subject).not_to permit(admin, admin)
      end

      it "does not permit a non-admin to update another user" do
        expect(subject).not_to permit(clinician, other_clinician)
      end
    end
  end
end
