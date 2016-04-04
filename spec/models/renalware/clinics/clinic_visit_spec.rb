require "rails_helper"

describe Renalware::Clinics::ClinicVisit, type: :model do
  it { should belong_to :patient }

  it { should validate_presence_of :date }
  it { should validate_presence_of :clinic }

  it { is_expected.to validate_timeliness_of(:date) }

  describe "bmi" do
    let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

    subject { create(:clinic_visit, height: 1.7, weight: 82.5, patient: patient) }

    it "is calculated from height and weight" do
      expect(subject.bmi).to eq(28.55)
    end
  end

  describe "bp" do
    it "should format systolic and diastolic pressures" do
      subject.diastolic_bp = 85
      subject.systolic_bp = 112
      expect(subject.bp).to eq("112/85")
    end
  end
  describe "bp=" do
    it "writes to systolic and diastolic attributes" do
      subject.bp = "112/82"
      expect(subject.diastolic_bp).to eq(82)
      expect(subject.systolic_bp).to eq(112)
    end
  end
end
