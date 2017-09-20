require "rails_helper"

RSpec.describe Renalware::Admissions::Request, type: :model do
  it { is_expected.to validate_presence_of :patient }
  it { is_expected.to validate_presence_of :reason }
  it { is_expected.to validate_presence_of :updated_by }
  it { is_expected.to validate_presence_of :created_by }
  it { is_expected.to respond_to :position }

  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end
end
