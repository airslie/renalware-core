require "rails_helper"

module Renalware::HD
  RSpec.describe MasterDiary, type: :model do
    it { is_expected.to have_many(:weekly_diaries) }
    describe "#master" do
      it "defaults to false" do
        expect(described_class.new.master?).to be_truthy
      end
    end

    describe "only allows one master diary per hospital unit" do
      let(:unit){ create(:hospital_unit)}
      let(:user){ create(:user) }

      subject{ create(:hd_master_diary, hospital_unit_id: unit.id, by: user) }

      it { is_expected.to validate_uniqueness_of(:hospital_unit_id) }
    end
  end
end
