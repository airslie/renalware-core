require "rails_helper"

module Renalware::Letters
  describe LetterPolicy, type: :policy do
    subject { described_class }

    permissions :author? do
      it "grants access if user super_admin" do
        expect(subject).to permit(FactoryBot.create(:user, :super_admin))
      end

      it "grants access if user admin" do
        expect(subject).to permit(FactoryBot.create(:user, :admin))
      end

      it "denies access if user clinician" do
        expect(subject).to permit(FactoryBot.create(:user, :read_write))
      end

      it "denies access if user read_only" do
        expect(subject).not_to permit(FactoryBot.create(:user, :read_only))
      end
    end
  end
end
