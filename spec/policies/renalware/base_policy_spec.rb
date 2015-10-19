require "rails_helper"

module Renalware
  describe BasePolicy, type: :policy do
    let(:super_admin) { create(:user, :approved, :super_admin) }
    let(:admin) { create(:user, :approved, :admin) }
    let(:clinician) { create(:user, :approved, :clinician) }

    it 'checks and defines permissions for super admins' do
      policy = BasePolicy.new(super_admin, User.new)
      expect(policy.create?).to be true

      policy = BasePolicy.new(super_admin, DrugType.new)
      expect(policy.create?).to be true
    end

    it 'checks and defines permissions for admins' do
      policy = BasePolicy.new(admin, Role.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(admin, DrugType.new)
      expect(policy.create?).to be true
    end

    it 'checks and defines permissions for clinicians' do
      policy = BasePolicy.new(clinician, User.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(clinician, DrugType.new)
      expect(policy.create?).to be false

      policy = BasePolicy.new(clinician, Patient.new)
      expect(policy.create?).to be true
    end
  end
end
