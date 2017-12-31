require "rails_helper"

RSpec.describe Renalware::Admissions::Consult, type: :model do
  it { is_expected.to validate_presence_of :patient_id }
  it { is_expected.to validate_presence_of :started_on }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :consult_type }
  it { is_expected.to respond_to(:by=) } # accountable
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:consult_site) }
  it { is_expected.to belong_to(:hospital_ward) }

  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end

  describe "validation" do
    context "when consult_site_id and hospital_ward_id are not present" do
      subject{ described_class.new(consult_site_id: nil, hospital_ward_id: nil) }

      it { is_expected.to validate_presence_of :other_site_or_ward }
    end

    context "when consult_site_id is present and hospital_ward_id is not" do
      subject{ described_class.new(consult_site_id: 1, hospital_ward_id: nil) }

      it { is_expected.not_to validate_presence_of :other_site_or_ward }
    end

    context "when consult_site_id is not present and hospital_ward_id is" do
      subject{ described_class.new(consult_site_id: nil, hospital_ward_id: 1) }

      it { is_expected.not_to validate_presence_of :other_site_or_ward }
    end
  end
end
