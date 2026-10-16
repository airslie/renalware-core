module Renalware::HD::Scheduling
  describe WeeklyDiary do
    describe "#applies_to_current_week?" do
      it "is true for the diary of the current ISO week" do
        today = Time.zone.today
        diary = build(:hd_weekly_diary, week_number: today.cweek, year: today.year)

        expect(diary.applies_to_current_week?).to be(true)
      end

      it "is false for another week" do
        diary = build(:hd_weekly_diary, week_number: 2, year: 2017)

        expect(diary.applies_to_current_week?).to be(false)
      end
    end

    describe "#archived?" do
      it "is always false" do
        expect(build(:hd_weekly_diary).archived?).to be(false)
      end
    end

    describe ".ordered" do
      it "returns the most recent weeks first" do
        master = create(:hd_master_diary)
        unit = master.hospital_unit
        old = create(:hd_weekly_diary, master_diary: master, hospital_unit: unit,
                                       year: 2017, week_number: 50)
        newest = create(:hd_weekly_diary, master_diary: master, hospital_unit: unit,
                                          year: 2018, week_number: 3)
        middle = create(:hd_weekly_diary, master_diary: master, hospital_unit: unit,
                                          year: 2017, week_number: 52)

        expect(described_class.where(hospital_unit: unit).ordered).to eq([newest, middle, old])
      end
    end
  end
end
