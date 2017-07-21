require "rails_helper"

describe Renalware::Clinics::ClinicVisit, type: :model do
  it { is_expected.to be_versioned }
  it { is_expected.to belong_to :patient }

  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :clinic }
  it { is_expected.to validate_timeliness_of(:date) }
  it { is_expected.to validate_timeliness_of(:time) }
  it { is_expected.not_to validate_presence_of :time }
  it { is_expected.not_to validate_presence_of :pulse }
  it { is_expected.not_to validate_presence_of :temperature }
  it { is_expected.not_to validate_presence_of(:admin_notes) }

  describe "bmi" do
    subject { create(:clinic_visit, height: 1.7, weight: 82.5, patient: patient) }

    let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

    it "is calculated from height and weight" do
      expect(subject.bmi).to eq(28.55)
    end
  end

  describe "bp" do
    it "formats systolic and diastolic pressures" do
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
