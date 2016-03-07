require 'rails_helper'

module Renalware
  module Letters
    describe Letter, type: :model do
      subject { create(:letter) }

      it { should validate_presence_of :author }
      it { should validate_presence_of :description_id }
      it { should validate_presence_of :recipient }
      it { should validate_presence_of :recipient_address }
      it { should validate_presence_of :state }

      describe 'title' do
        it 'titleizes the class name' do
          expect(subject.title).to eq('Letter')
        end
      end
    end
  end
end