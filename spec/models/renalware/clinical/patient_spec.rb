require "rails_helper"

RSpec.describe Renalware::Clinical::Patient, type: :model do
  it { is_expected.to have_many :allergies }

  describe "#allergy_status" do
    it "defaults to unrecorded" do
      expect(subject.allergy_status.unrecorded?).to eq(true)
    end
  end
end
