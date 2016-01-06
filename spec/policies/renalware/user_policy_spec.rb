require "rails_helper"

module Renalware

  describe UserPolicy, type: :policy do
    let(:clinician) { create(:user, :clinician) }
    let(:admin) { create(:user, :super_admin) }

    subject { described_class }

    permissions :update? do
      it "denies access if user tries to update itself" do
        expect(subject).to_not permit(admin, admin)
      end

      it "grants access if user updates another user" do
        expect(subject).to permit(admin, clinician)
      end
    end
  end
end