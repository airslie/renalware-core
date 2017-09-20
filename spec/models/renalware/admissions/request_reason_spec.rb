require "rails_helper"

RSpec.describe Renalware::Admissions::RequestReason, type: :model do
  it { is_expected.to validate_presence_of :description }
  it "is paranoid" do
    expect(described_class).to respond_to(:deleted)
  end
end
