require 'rails_helper'

module Renalware
  describe Ability, :type => :model do

    let(:super_admin) { create(:user, :approved, :super_admin) }
    let(:admin) { create(:user, :approved, :admin) }
    let(:clinician) { create(:user, :approved, :clinician) }

    it 'checks and defines permissions for super admins' do
      super_admin_ability = Ability.new(super_admin)
      expect(super_admin_ability.can?(:manage, :all)).to be true
    end
    it 'checks and defines permissions for admins' do
      admin_ability = Ability.new(admin)
      expect(admin_ability.can?(:manage, Drug.new)).to be true
      expect(admin_ability.cannot?(:manage, User.new)).to be true
    end
    it 'checks and defines permissions for clinicians' do
      clinician_ability = Ability.new(clinician)
      expect(clinician_ability.can?(:manage, Patient.new)).to be true
      expect(clinician_ability.cannot?(:manage, Drug.new)).to be true
      expect(clinician_ability.cannot?(:manage, User.new)).to be true
    end
  end
end