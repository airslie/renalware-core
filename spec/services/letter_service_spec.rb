require 'rails_helper'

describe LetterService, type: :service do
  describe 'update!' do
    let(:letter) { build(:letter) }
    subject { LetterService.new(letter) }

    context 'on a Letter to the patient' do
      before do
        @actual = subject.update!(recipient: 'patient')
      end

      it 'populates the recipient_address' do
        expect(letter.recipient_address).to eq(letter.patient.current_address)
      end

      it 'returns true' do
        expect(@actual).to be true
      end
    end

    context 'on a Letter to the GP' do
      context 'belonging to a practice' do
        before do
          letter.doctor.practices << letter.patient.practice
          @actual = subject.update!(recipient: 'doctor')
        end

        it 'populates the recipient address with the practice address' do
          expect(letter.recipient_address).to eq(letter.patient.practice.address)
        end
      end

      context 'without a practice' do
        before do
          @actual = subject.update!(recipient: 'doctor')
        end

        it 'populates the recipient address with the doctor address' do
          expect(letter.recipient_address).to eq(letter.doctor.address)
        end

        it 'returns true' do
          expect(@actual).to be true
        end
      end
    end

    context 'on a Letter to other recipients' do
      context 'when an address is supplied' do
        it 'creates a new address' do
          subject.update!(recipient: 'other', other_recipient_address: 'North Street, Town Centre, Ashby-de-la-Zouch, LE65 1HU')
          expect(letter.recipient_address.street_1).to eq('North Street')
          expect(letter.recipient_address.street_2).to eq('Town Centre')
          expect(letter.recipient_address.city).to eq('Ashby-de-la-Zouch')
          expect(letter.recipient_address.postcode).to eq('LE65 1HU')
        end
      end
      context 'when a partial address is supplied' do
        it 'creates a new address' do
        end
      end
      context 'when too little address info is supplied' do
      end
    end
  end
end
