require 'rails_helper'

shared_examples_for Supersedeable do

  subject { described_class.new }

  describe 'paranoia' do
    it 'should soft delete with acts_as_paranoid' do
      expect(subject.paranoia_column?).to be true
    end
  end

  describe 'supersede! instance method' do
    it 'duplicates the current instance' do
      clone = double(:clone)
      expect(subject).to receive(:dup).and_return(clone)
      expect(clone).to receive(:save!)

      actual = subject.supersede!
    end
    it 'soft deletes the cloned model' do
      expect(subject).to receive(:destroy!)
      subject.supersede!
    end
    it 'saves the clone' do
      actual = subject.supersede!
      expect(actual.reload).not_to be_nil
    end
    it 'updates the clone with given attributes' do
      actual = subject.supersede!(id: 999)
      expect(actual.reload.id).to eq(999)
      expect(subject.id).not_to eq(999)
    end
  end
end


describe Modality do
  it_behaves_like Supersedeable do
    subject { create(:modality) }
    it 'duplicates associations' do
      actual = subject.supersede!
      expect(actual.patient).to eq(subject.patient)
    end
  end
end
