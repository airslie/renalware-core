require "rails_helper"

module Renalware
  module HD
    describe Station, type: :model do
      it { is_expected.to validate_presence_of(:hospital_unit_id) }
      it { is_expected.to belong_to(:location) }

      describe "#name is unique in the scope of the unit" do
        let(:user){ create(:user) }
        let(:unit){ create(:hospital_unit) }
        let(:station) { create(:hd_station, hospital_unit_id: unit.id, name: "A", by: user) }

        subject do
          described_class.new(name: station.name, hospital_unit_id: station.hospital_unit_id)
        end

        it { is_expected.to validate_uniqueness_of(:name).scoped_to(:hospital_unit_id) }
      end
    end
  end
end
