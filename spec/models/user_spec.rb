require 'rails_helper'

describe User, :type => :model do

  it { should have_and_belong_to_many :roles }

  describe 'class' do
    it 'includes Deviseable to authenticate using Devise' do
      expect(User.ancestors).to include(Deviseable)
      expect(User.devise_modules).to match_array(%i(expirable database_authenticatable rememberable recoverable registerable validatable trackable))
    end
  end

  it 'is unapproved by default' do
    expect(build(:user)).not_to be_approved
  end

  describe 'read_only?' do
    it 'denotes a user with the read_only role' do
      expect(create(:user, :read_only)).to be_read_only
    end
  end
end
