require 'rails_helper'

RSpec.describe MedicationsHelper, :type => :helper do
  before do
    @patient = FactoryGirl.create(:patient)
    @blue_pill = FactoryGirl.create(:drug)
    @amoxicillin = FactoryGirl.create(:drug, name: 'Amoxicillin')
  end

  describe 'display_med_field' do
    context 'value submitted' do
      it 'should return changed/persisted value.' do
        @patient_medication = FactoryGirl.build(
          :medication,
          patient: @patient,
          medicatable: @blue_pill,
          medicatable_type: 'Drug',
          dose: nil,
          medication_route_id: nil,
          frequency: nil,
          start_date: nil,
          provider: nil)

        @patient_medication.save
        expect(display_med_field(@patient_medication, @patient_medication.medicatable, :name)).to eq(@patient_medication.medicatable.send(:name))
      end
    end

    context 'value not submitted' do
      it 'should not return changed/persisted value.' do
        @patient_medication = FactoryGirl.build(
          :medication,
          patient: @patient,
          medicatable: nil,
          medicatable_type: nil,
          dose: nil,
          medication_route_id: nil,
          frequency: nil,
          start_date: nil,
          provider: nil)

        @patient_medication.save
        expect(display_med_field(@patient_medication, @patient_medication.medicatable, :name)).to eq(nil)
      end
    end
  end

  describe 'highlight_validation_fail' do

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
          medicatable: @amoxicillin,
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
