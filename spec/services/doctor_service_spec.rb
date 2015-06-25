require 'rails_helper'

describe DoctorService do
  describe 'update!' do
    context 'for an unsaved Doctor' do
      it 'creates a new Doctor record' do
        expect {
          DoctorService.new.update!(doctor_params.merge(address: create(:address)))
        }.to change(Doctor, :count).by(1)
      end

      it 'assigns practices based on practice_ids params' do
        practice = create(:practice)
        expect {
          DoctorService.new.update!(doctor_params.merge(practice_ids: [practice.to_param]))
        }.to change(practice.doctors, :count).by(1)
      end
    end

    context 'for an existing Doctor' do
      before do
        @doctor = create(:doctor, first_name: 'John', last_name: 'Merrill')
      end

      it 'updates the existing record' do
        DoctorService.new(@doctor).update!(doctor_params)

        expect(@doctor.reload.first_name).to eq('Barry')
        expect(@doctor.last_name).to eq('Foster')
      end

      it 'updates the existing practices' do
        practice = create(:practice)

        DoctorService.new(@doctor).update!(doctor_params.merge(practice_ids: [practice.to_param]))

        expect(@doctor.reload.practices).to include(practice)
      end
    end
  end
end

def doctor_params
  {
    first_name: 'Barry',
    last_name: 'Foster',
    email: 'barry.foster@nhs.net',
    practitioner_type: 'GP'
  }
end

def address_params
  {street_1: '123 South Street', postcode: 'N1 1NN'}
end
