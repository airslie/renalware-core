require "rails_helper"

module Renalware::Hospitals
  RSpec.describe Ward, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:hospital_unit) }
    it { is_expected.to belong_to(:hospital_unit) }

    describe "uniqueness" do
      let(:unit) { create(:hospital_unit) }
      subject { described_class.new(name: "X", hospital_unit_id: unit.id) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:hospital_unit_id) }
    end
  end
end
