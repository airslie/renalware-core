require "rails_helper"

module Renalware
  describe UpdateUser do
    describe "#call" do
      let(:super_admin) { find_or_create_role(:super_admin) }

      context "given an unapproved user" do
        let (:user) { create(:user, :clinician) }

        subject { UpdateUser.new(user) }

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
        let (:user) { create(:user, :approved) }
        subject { UpdateUser.new(user) }

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
        let (:user) { build_stubbed(:user, :expired) }
        subject { UpdateUser.new(user) }

        it "unexpires the user" do
          expect(user).to receive(:expired_at=).with(nil)
          subject.call(unexpire: "true")
        end

        it "notifies the user of account reactivation" do
          expect{subject.call(unexpire: "true")}.to change(
            ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context "given an unexpired user" do
        let (:user) { build_stubbed(:user, :approved) }
        subject { UpdateUser.new(user) }

        it "skips unexpiry" do
          expect(subject).not_to receive(:unexpire)
          expect{subject.call(unexpire: "true")}.to change(
            ActionMailer::Base.deliveries, :count).by(0)
        end
      end
    end
  end
end
