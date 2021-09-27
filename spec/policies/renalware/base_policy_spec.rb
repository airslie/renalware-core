# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe BasePolicy, type: :policy do
    include RolesSpecHelper

    let(:super_admin) { user_with_role(:super_admin) }
    let(:admin) { create(:user, :admin) }
    let(:clinician) { create(:user, :clinical) }

    it "checks and defines permissions for super admins" do
      policy = BasePolicy.new(super_admin, User.new)
      expect(policy.create?).to be true

      policy = BasePolicy.new(super_admin, Drugs::Type.new)
      expect(policy.create?).to be true
    end

    it "checks and defines permissions for admins" do
      policy = BasePolicy.new(admin, Role.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(admin, Drugs::Type.new)
      expect(policy.create?).to be true
    end

    it "checks and defines permissions for clinicians" do
      policy = BasePolicy.new(clinician, User.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(clinician, Drugs::Type.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(clinician, Patient.new)
      expect(policy.create?).to be true
    end
  end
end
