require "rails_helper"

module Renalware
  module Transplants
    describe NHSBTWaitListUploadPolicy do
      subject(:policy) { described_class.new(user, NHSBTWaitListUpload) }

      context "when the user is an admin" do
        let(:user) { create(:user, :admin) }

        it "permits upload actions" do
          expect(policy.new?).to be(true)
          expect(policy.create?).to be(true)
          expect(policy.show?).to be(true)
          expect(policy.import?).to be(true)
        end
      end

      context "when the user is a super admin" do
        let(:user) { create(:user, :super_admin) }

        it "permits upload actions" do
          expect(policy.new?).to be(true)
          expect(policy.create?).to be(true)
          expect(policy.show?).to be(true)
          expect(policy.import?).to be(true)
        end
      end

      context "when the user is clinical" do
        let(:user) { create(:user, :clinical) }

        it "denies upload actions" do
          expect(policy.new?).to be(false)
          expect(policy.create?).to be(false)
          expect(policy.show?).to be(false)
          expect(policy.import?).to be(false)
        end
      end
    end
  end
end
