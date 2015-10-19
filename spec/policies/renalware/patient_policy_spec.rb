require "rails_helper"

module Renalware

  describe PatientPolicy, type: :policy do

    subject { described_class }

    permissions :death_update?, :death? do
      it "grants access if user super_admin" do
        expect(subject).to permit(FactoryGirl.create(:user, :super_admin))
      end

      it "grants access if user admin" do
        expect(subject).to permit(FactoryGirl.create(:user, :admin))
      end

      it "denies access if user clinician" do
        expect(subject).to permit(FactoryGirl.create(:user, :clinician))
      end

      it "denies access if user read_only" do
        expect(subject).to_not permit(FactoryGirl.create(:user, :read_only))
      end
    end
  end
end