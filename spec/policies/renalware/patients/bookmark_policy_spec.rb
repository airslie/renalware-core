require "rails_helper"

module Renalware::Patients
  describe BookmarkPolicy, type: :policy do
    subject { described_class }

    permissions :create? do
      it "grants access if user super_admin" do
        expect(subject).to permit(FactoryBot.create(:user, :super_admin))
      end

      it "grants access if user admin" do
        expect(subject).to permit(FactoryBot.create(:user, :admin))
      end

      it "denies access if user clinician" do
        expect(subject).to permit(FactoryBot.create(:user, :clinical))
      end

      it "denies access if user read_only" do
        expect(subject).not_to permit(FactoryBot.create(:user, :read_only))
      end
    end
  end
end
