module Renalware
  describe BloodGroupDescription do
    subject { build(:blood_group_description) }

    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to have_db_index(:code).unique(true) }
    it { is_expected.to have_db_index(:name).unique(true) }

    describe ".enabled_ordered" do
      it "returns enabled descriptions ordered by position then name" do
        create(:blood_group_description, code: "B", name: "B", position: 3)
        create(:blood_group_description, code: "A2", name: "A2", position: 2)
        create(:blood_group_description, code: "A1", name: "A1", position: 2)
        create(:blood_group_description, code: "O", name: "O", position: 1, enabled: false)

        expect(described_class.enabled_ordered.map(&:code)).to eq(%w(A1 A2 B))
      end
    end

    describe ".pluck_for_dropdown" do
      it "returns labels and stored codes for enabled descriptions" do
        create(:blood_group_description, code: "A1", name: "A1", position: 1)
        create(:blood_group_description, code: "O", name: "O", position: 2, enabled: false)

        expect(described_class.pluck_for_dropdown).to eq([%w(A1 A1)])
      end
    end
  end
end
