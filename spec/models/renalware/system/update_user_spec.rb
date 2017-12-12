require "rails_helper"

module Renalware::System
  describe UpdateUser do
    describe "#call" do
      let(:super_admin) { create(:role, :super_admin) }

      context "given an unapproved user" do
        subject { UpdateUser.new(user) }

        let(:user) { create(:user, :clinical, :unapproved) }

        it "approves the user" do
          expect(user).to receive(:approved=).with(true)
          subject.call(approved: "true")
        end

        it "authorises the user" do
          expect(user).to receive(:roles=).with([super_admin])
          subject.call(approved: "true", roles: [super_admin])
        end

        it "notifies the user of approval" do
          expect {
            subject.call(approved: "true", roles: [super_admin])
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by(1)
        end

        it "does not approve a user without roles" do
          actual = subject.call(approved: "true", roles: [])
          expect(actual).to be false
        end
      end

      context "given an approved user" do
        subject { UpdateUser.new(user) }

        let(:user) { create(:user) }

        it "skips approval" do
          expect(subject).not_to receive(:approve)
          expect{
            subject.call(approved: "true")
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by(0)
        end

        it "authorises the user" do
          expect(user).to receive(:roles=).with([super_admin])
          subject.call(approved: "true", roles: [super_admin])
        end
      end

      context "given an expired user" do
        subject { UpdateUser.new(user) }

        let(:user) { build(:user, :expired) }

        it "unexpires the user" do
          expect(user).to receive(:expired_at=).with(nil)
          subject.call(unexpire: "true")
        end

        it "notifies the user of account reactivation" do
          expect{ subject.call(unexpire: "true") }.to change(
            ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context "given an unexpired user" do
        subject { UpdateUser.new(user) }

        let(:user) { build(:user) }

        it "skips unexpiry" do
          expect(subject).not_to receive(:unexpire)
          expect{ subject.call(unexpire: "true") }.to change(
            ActionMailer::Base.deliveries, :count).by(0)
        end
      end
    end
  end
end
