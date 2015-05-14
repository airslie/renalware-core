require 'rails_helper'

describe User, :type => :model do

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
