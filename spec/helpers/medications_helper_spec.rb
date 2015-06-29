require 'rails_helper'

RSpec.describe MedicationsHelper, :type => :helper do

  describe 'highlight_validation_fail' do
    before do
      @patient = FactoryGirl.create(:patient)
    end

    context 'with errors' do
      it 'should apply hightlight' do
        @patient_medication = FactoryGirl.build(
          :medication,
          patient: @patient,
          medicatable_id: nil,
          dose: nil,
          medication_route_id: nil,
          frequency: nil,
          start_date: nil,
          provider: nil)

        @patient_medication.save
        expect(highlight_validation_fail(@patient_medication, :medicatable_id)).to eq('field_with_errors')
      end
    end

    context 'with no errors' do
      it 'should not apply highlight' do
        @patient_medication = FactoryGirl.build(
          :medication,
          patient: @patient,
          medicatable_id: 2,
          medicatable_type: 'Drug',
          dose: '23mg',
          medication_route_id: 1,
          frequency: 'PID',
          start_date: '02/10/2014',
          provider: 0)

        @patient_medication.save
        expect(highlight_validation_fail(@patient_medication, :medicatable)).to eq(nil)
      end
    end

  end

end
