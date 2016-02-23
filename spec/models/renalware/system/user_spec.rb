require 'rails_helper'
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe User, type: :model do

    it_behaves_like 'Personable'

    it { should validate_presence_of(:professional_position).on(:update) }
    it { should validate_presence_of(:signature).on(:update) }

    describe 'class' do
      it 'includes Deviseable to authenticate using Devise' do
        expect(User.ancestors).to include(Deviseable)
        expect(User.devise_modules).to match_array(%i(expirable database_authenticatable rememberable registerable validatable trackable))
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

    describe 'scopes' do
      describe 'unapproved' do
        it 'retrieves unapproved users' do
          approved = create(:user, :approved)
          unapproved = create(:user)

          actual = User.unapproved
          expect(actual.size).to eq(1)
          expect(actual).to include(unapproved)
          expect(actual).not_to include(approved)
        end
      end
      describe 'inactive' do
        it 'retrieves inactive users' do
          active = create(:user, last_activity_at: 1.minute.ago)
          inactive = create(:user, last_activity_at: 60.days.ago)

          actual = User.inactive
          expect(actual.size).to eq(1)
          expect(actual).to include(inactive)
          expect(actual).not_to include(active)
        end
      end
      describe 'author' do
        it 'retrieves users with a signature' do
          author = create(:user, signature: 'Dr D.O. Good')
          unsigned = create(:user, signature: nil)

          actual = User.author
          expect(actual).to include(author)
          expect(actual).not_to include(unsigned)
        end
      end
    end
  end
end
