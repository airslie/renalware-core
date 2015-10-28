require 'rails_helper'

module Renalware
  describe Modality, :type => :model do
    it { should belong_to(:modality_code) }
    it { should belong_to(:patient) }
    it { should belong_to(:modality_reason) }
    it { should validate_presence_of :started_on }

    describe 'transfer!' do
      subject { create(:modality) }
      let(:started_on) { Date.parse('2015-04-21') }

      before do
        @actual = subject.transfer!(notes: 'Some notes', started_on: started_on)
      end

      it 'updates the end date' do
        expect(subject.ended_on).to eq(started_on)
      end

      it 'soft deletes the current modality' do
        expect(subject.deleted_at).not_to be_nil
      end

      it 'creates a new modality with the attributes passed' do
        expect(@actual.notes).to eq('Some notes')
        expect(@actual.started_on).to eq(started_on)
      end
    end
  end
end