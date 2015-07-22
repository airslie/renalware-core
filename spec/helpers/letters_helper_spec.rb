require 'rails_helper'

describe LettersHelper do
  include RSpecHtmlMatchers

  describe 'patient_medications' do
    let(:amoxicillin_200_mg) { double(:amoxicillin_200_mg, start_date: 10.days.ago, formatted: "Amoxicillin, 200mg, PO, Twice Daily, #{10.days.ago}") }
    let(:penicillin_150_mg) { double(:penicillin_150_mg, start_date: 15.days.ago, formatted: "Penicillin, 150mg, PO, Daily, #{15.days.ago}") }
    let(:patient) { double(:patient, medications: [amoxicillin_200_mg, penicillin_150_mg]) }

    subject { build_stubbed(:letter) }

    before do
      allow(subject).to receive(:patient).and_return(patient)
    end

    it 'formats patient medications as html' do
      expect(patient_medications(subject)).to have_tag('li', with: { class: 'strong'}) { with_text("Amoxicillin, 200mg, PO, Twice Daily, #{10.days.ago}") }
      expect(patient_medications(subject)).to have_tag('li') { with_text("Penicillin, 150mg, PO, Daily, #{15.days.ago}") }
    end
  end
  describe 'patient_problems' do
    let(:leg_pain) { double(:leg_pain, formatted: 'Leg pain, 01/01/2015') }
    let(:chest_pain) { double(:chest_pain, formatted: 'Chest pain, 09/09/2015' ) }
    let(:patient) { double(:patient, problems: [leg_pain, chest_pain]) }

    subject { build_stubbed(:letter) }

    before do
      allow(subject).to receive(:patient).and_return(patient)
    end

    it 'formats patient problems as html' do
      actual = patient_problems(subject)
      expect(actual).to have_tag('h6') { with_text('Problems') }
      expect(actual).to have_tag('li') { with_text('Leg pain, 01/01/2015') }
      expect(actual).to have_tag('li') { with_text('Chest pain, 09/09/2015') }
    end
  end
  describe 'patient_and_doctor_info' do
    it 'formats patient and doctor information' do
    end
  end
end
