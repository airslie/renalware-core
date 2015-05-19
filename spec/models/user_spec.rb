require 'rails_helper'

describe User, :type => :model do

  it { should have_and_belong_to_many :roles }

  describe 'class' do
    it 'includes Deviseable to authenticate using Devise' do
      expect(User.ancestors).to include(Deviseable)
      expect(User.devise_modules).to match_array(%i(database_authenticatable rememberable recoverable registerable validatable trackable))
    end
  end

  it 'is approvable' do
    expect(build(:user)).not_to be_approved
  end
end
