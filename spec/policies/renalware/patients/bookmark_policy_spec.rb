# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients
  describe BookmarkPolicy, type: :policy do
    include RolesSpecHelper
    subject(:policy) { described_class }

    permissions :create? do
      it "grants access if user super_admin" do
        expect(policy).to permit(user_with_role(:super_admin))
      end

      it "grants access if user admin" do
        expect(policy).to permit(user_with_role(:admin))
      end

      it "denies access if user clinician" do
        expect(policy).to permit(user_with_role(:clinical))
      end

      it "denies access if user read_only" do
        expect(policy).not_to permit(user_with_role(:read_only))
      end
    end
  end
end
