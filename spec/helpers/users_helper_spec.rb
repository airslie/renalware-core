require 'rails_helper'

RSpec.describe UsersHelper, :type => :helper do

  describe 'current_user_is_super_admin?' do
    context 'with a super admin user' do
      let(:current_user) { create(:user, :approved, :super_admin) }
      it 'is true' do
        expect(current_user_is_super_admin?).to be true
      end
    end
    context 'with an admin user' do
      let(:current_user) { create(:user, :approved, :admin) }
      it 'is false' do
        expect(current_user_is_super_admin?).to be false
      end
    end
  end
  describe 'current_user_is_admin?' do
    context 'with a super admin user' do
      let(:current_user) { create(:user, :approved, :super_admin) }
      it 'is true' do
        expect(current_user_is_admin?).to be true
      end
    end
    context 'with an admin user' do
      let(:current_user) { create(:user, :approved, :admin) }
      it 'is true' do
        expect(current_user_is_admin?).to be true
      end
    end
    context 'with a clinician' do
      let(:current_user) { create(:user, :approved, :clinician) }
      it 'is false' do
        expect(current_user_is_admin?).to be false
      end
    end
  end
end
