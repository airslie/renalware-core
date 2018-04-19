# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe LetterPolicy, type: :policy do
    subject(:policy) { described_class }

    permissions :author? do
      it "grants access if user super_admin" do
        expect(policy).to permit(create(:user, :super_admin))
      end

      it "grants access if user admin" do
        expect(policy).to permit(create(:user, :admin))
      end

      it "denies access if user clinician" do
        expect(policy).to permit(create(:user, :clinical))
      end

      it "denies access if user read_only" do
        expect(policy).not_to permit(create(:user, :read_only))
      end
    end

    permissions :destroy? do
      it "grants access if letter is draft" do
        expect(policy).to permit(build_stubbed(:user), Letter::Draft.new)
      end

      it "grants access if letter is pending review" do
        expect(policy).to permit(build_stubbed(:user), Letter::PendingReview.new)
      end

      it "does not grant access if letter is approved" do
        expect(policy).not_to permit(build_stubbed(:user), Letter::Approved.new)
      end

      it "does not grant access if letter is completed" do
        expect(policy).not_to permit(build_stubbed(:user), Letter::Completed.new)
      end
    end
  end
end
