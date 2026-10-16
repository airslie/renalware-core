module Renalware::HD::Scheduling
  describe FindOrCreateMasterDiary do
    let(:user) { create(:user) }
    let(:unit) { create(:hospital_unit) }

    it "creates a master diary for the unit when there is none" do
      expect { described_class.for_unit(unit.id, user) }
        .to change(MasterDiary, :count).by(1)

      diary = MasterDiary.find_by!(hospital_unit_id: unit.id)
      expect(diary).to be_master
      expect(diary.updated_by).to eq(user)
    end

    it "returns the existing master diary without creating another" do
      existing = create(:hd_master_diary, hospital_unit: unit)

      expect { expect(described_class.for_unit(unit.id, user)).to eq(existing) }
        .not_to change(MasterDiary, :count)
    end
  end
end
