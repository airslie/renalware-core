require "rails_helper"

module Renalware

  describe EventTypePolicy, type: :policy do
    subject { described_class }

    permissions :new? do
      it "grants access if user super_admin" do
        expect(subject).to permit(FactoryGirl.create(:user, :super_admin))
      end

      it "grants access if user admin" do
        expect(subject).to permit(FactoryGirl.create(:user, :admin))
      end

      it "denies access if user clinician" do
        expect(subject).to_not permit(FactoryGirl.create(:user, :clinician))
      end
    end

  end

end