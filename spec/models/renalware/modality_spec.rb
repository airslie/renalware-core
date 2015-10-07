require 'rails_helper'

module Renalware
  describe Modality, :type => :model do
    it { should belong_to(:modality_code) }
    it { should belong_to(:patient) }
    it { should belong_to(:modality_reason) }
    it { should validate_presence_of :start_date }

    describe 'transfer!' do
      subject { create(:modality) }
      let(:start_date) { Date.parse('2015-04-21') }

      before do
        @actual = subject.transfer!(notes: 'Some notes', start_date: start_date)
      end

      it 'updates the end date' do
        expect(subject.end_date).to eq(start_date)
      end

      it 'soft deletes the current modality' do
        expect(subject.deleted_at).not_to be_nil
      end

      it 'creates a new modality with the attributes passed' do
        expect(@actual.notes).to eq('Some notes')
        expect(@actual.start_date).to eq(start_date)
      end
    end
  end
end