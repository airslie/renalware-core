# frozen_string_literal: true

require "rails_helper"

module Renalware::System
  describe UpdateUser do
    describe "#call" do
      let(:super_admin) { create(:role, :super_admin) }

      context "with an unapproved user" do
        subject(:commmand) { UpdateUser.new(user) }

        let(:user) { create(:user, :clinical, :unapproved) }

        it "approves the user" do
          allow(user).to receive(:approved=)

          commmand.call(approved: "true")

          expect(user).to have_received(:approved=).with(true)
        end

        it "authorises the user" do
          allow(user).to receive(:roles=)

          commmand.call(approved: "true", roles: [super_admin])

          expect(user).to have_received(:roles=).with([super_admin])
        end

        it "notifies the user of approval" do
          expect {
            commmand.call(approved: "true", roles: [super_admin])
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by(1)
        end

        it "does not approve a user without roles" do
          actual = commmand.call(approved: "true", roles: [])
          expect(actual).to be false
        end
      end

      context "with an approved user" do
        subject(:command) { UpdateUser.new(user) }

        let(:user) { create(:user) }

        it "skips approval" do
          allow(command).to receive(:approve)

          command.call(approved: "true")

          expect(command).not_to have_received(:approve)
        end

        it "does not send an email" do
          expect{
            command.call(approved: "true")
          }.to change{
            ActionMailer::Base.deliveries.count
          }.by(0)
        end

        it "authorises the user" do
          allow(user).to receive(:roles=)

          command.call(approved: "true", roles: [super_admin])

          expect(user).to have_received(:roles=).with([super_admin])
        end
      end

      context "with an expired user" do
        subject(:command) { UpdateUser.new(user) }

        let(:user) { build(:user, :expired) }

        it "unexpires the user" do
          allow(user).to receive(:expired_at=)

          command.call(unexpire: "true")

          expect(user).to have_received(:expired_at=).with(nil)
        end

        it "notifies the user of account reactivation" do
          expect{
            command.call(unexpire: "true")
          }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context "with an unexpired user" do
        subject(:command) { UpdateUser.new(user) }

        let(:user) { build(:user) }

        it "skips unexpiry" do
          allow(command).to receive(:unexpire)

          command.call(unexpire: "true")

          expect(command).not_to have_received(:unexpire)
        end

        it "does not send an email" do
          expect{
            command.call(unexpire: "true")
          }.to change(ActionMailer::Base.deliveries, :count).by(0)
        end
      end
    end
  end
end
