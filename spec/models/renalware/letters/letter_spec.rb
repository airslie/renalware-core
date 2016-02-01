require 'rails_helper'

module Renalware
  describe Letter, type: :model do
    subject { create(:letter) }

    it { should validate_presence_of :letter_description_id }
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
