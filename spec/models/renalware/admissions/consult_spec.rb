require "rails_helper"

RSpec.describe Renalware::Admissions::Consult, type: :model do
  it { is_expected.to validate_presence_of :patient_id }
  it { is_expected.to respond_to(:by=) } # accountable
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to belong_to(:hospital_unit) }
  it { is_expected.to belong_to(:hospital_ward) }

  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end
end
