require 'rails_helper'

describe Clinic, type: :model do
  it { should belong_to :patient }
  it { should validate_presence_of :date }
  it { should validate_presence_of :height }
  it { should validate_presence_of :weight }
  it { should validate_presence_of :systolic_bp }
  it { should validate_presence_of :diastolic_bp }


  describe 'bmi' do
    subject { create(:clinic, height: 1.7, weight: 82.5) }

    it 'is calculated from height and weight' do
      expect(subject.bmi).to eq(28.55)
    end
  end
end
