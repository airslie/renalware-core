require 'rails_helper'

describe User, :type => :model do

  it { should have_and_belong_to_many :roles }

  describe 'class' do
    it 'includes Deviseable to authenticate using Devise' do
      expect(User.ancestors).to include(Deviseable)
      expect(User.devise_modules).to match_array(%i(database_authenticatable rememberable recoverable registerable validatable trackable))
    end
  end

  it 'is unapproved by default' do
    expect(build(:user)).not_to be_approved
  end

  describe 'authorise!' do
    subject { build(:user) }

    it 'optionally approves the user' do
      expect(subject).to receive(:approve)
      subject.authorise!([], true)
    end
    it 'sets the Roles on the user' do
      expect(subject).to receive(:roles=).with([:foo, :bar])
      expect(subject).not_to receive(:approve)
      subject.authorise!([:foo, :bar], false)
    end

    it 'notifies the user of authorisation' do
      role = find_or_create_role(:super_admin)
      expect { subject.authorise!([role], true) }.to change {ActionMailer::Base.deliveries.count}.by(1)
    end
  end
end
