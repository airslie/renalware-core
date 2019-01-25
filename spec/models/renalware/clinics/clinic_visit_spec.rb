# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::ClinicVisit, type: :model do
  it_behaves_like "an Accountable model"

  it :aggregate_failures do
    is_expected.to be_versioned
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to validate_presence_of :date
    is_expected.to validate_presence_of :clinic
    is_expected.to validate_timeliness_of(:date)
    is_expected.to validate_timeliness_of(:time)
    is_expected.not_to validate_presence_of :time
    is_expected.not_to validate_presence_of :pulse
    is_expected.not_to validate_presence_of :temperature
    is_expected.not_to validate_presence_of(:admin_notes)
    is_expected.to respond_to(:document)
    is_expected.to have_db_index(:document)
  end

  describe "bmi" do
    subject(:visit) { build_stubbed(:clinic_visit, height: 1.7, weight: 82.5, patient: patient) }

    let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

    it "is calculated from height and weight" do
      expect(visit.bmi).to eq(28.5)
    end
  end

  describe "bp" do
    it "formats systolic and diastolic pressures" do
      visit = described_class.new(diastolic_bp: 85, systolic_bp: 112)

      expect(visit.bp).to eq("112/85")
    end
  end

  describe "bp=" do
    it "writes to systolic and diastolic attributes" do
      visit = described_class.new(bp: "112/82")

      expect(visit).to have_attributes(
        diastolic_bp: 82,
        systolic_bp: 112
      )
    end
  end

  describe "#document" do
    subject { described_class.new.document }

    it { is_expected.to be_a(::Document::Embedded) }
  end
end
