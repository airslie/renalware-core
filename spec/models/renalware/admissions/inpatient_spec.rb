require "rails_helper"

RSpec.describe Renalware::Admissions::Inpatient, type: :model do
  it { is_expected.to validate_presence_of :patient_id }
  it { is_expected.to validate_presence_of :hospital_unit_id }
  it { is_expected.to validate_presence_of :hospital_ward_id }
  it { is_expected.to validate_presence_of :admitted_on }
  it { is_expected.to validate_presence_of :reason_for_admission }
  it { is_expected.to validate_presence_of :admission_type }
  it { is_expected.to respond_to(:by=) } # accountable
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:hospital_unit) }
  it { is_expected.to belong_to(:hospital_ward) }

  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end
end
