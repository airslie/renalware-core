describe "HD diary pages" do
  let(:user) { Renalware::User.first || create(:user) }
  let(:unit) { create(:hd_hospital_unit) }
  let(:am) { create(:hd_diurnal_period_code, :am) }
  let(:master_diary) { create(:hd_master_diary, hospital_unit: unit) }

  describe "GET index" do
    it "lists only the unit's weekly diaries, most recent first" do
      create(:hd_weekly_diary, master_diary:, hospital_unit: unit, year: 2018, week_number: 3)
      create(:hd_weekly_diary, master_diary:, hospital_unit: unit, year: 2018, week_number: 9)
      other = create(:hd_weekly_diary, year: 2018, week_number: 40)

      get hd_scheduling_unit_diaries_path(unit)

      expect(response).to be_successful
      body = response.body
      expect(body.index(">9<")).to be < body.index(">3<")
      expect(body).not_to include(">#{other.week_number}<")
    end
  end

  describe "GET edit" do
    it "renders existing weekly and recurring master slots for the requested week" do
      station = create(:hd_station, hospital_unit: unit)
      weekly = create(:hd_weekly_diary, master_diary:, hospital_unit: unit,
                                        year: 2018, week_number: 33)
      weekly_patient = create(:hd_patient, family_name: "Weekly", given_name: "Wendy")
      master_patient = create(:hd_patient, family_name: "Master", given_name: "Mo")
      create(:hd_diary_slot, diary: weekly, station:, diurnal_period_code: am, day_of_week: 1,
                             patient: weekly_patient, by: user)
      create(:hd_diary_slot, diary: master_diary, station:, diurnal_period_code: am,
                             day_of_week: 2, patient: master_patient, by: user,
                             created_at: Time.zone.local(2018, 1, 1))

      get hd_scheduling_unit_edit_diary_path(unit, week_number: 33, year: 2018)

      expect(response).to be_successful
      expect(response.body).to include("WEEKLY, Wendy")
      expect(response.body).to include("MASTER, Mo")
    end

    it "does not show master slots created after the requested week" do
      station = create(:hd_station, hospital_unit: unit)
      master_patient = create(:hd_patient, family_name: "Future", given_name: "Fay")
      create(:hd_diary_slot, diary: master_diary, station:, diurnal_period_code: am,
                             day_of_week: 2, patient: master_patient, by: user)

      get hd_scheduling_unit_edit_diary_path(unit, week_number: 33, year: 2018)

      expect(response.body).not_to include("FUTURE, Fay")
    end

    it "does not create a duplicate diary on repeat visits" do
      path = hd_scheduling_unit_edit_diary_path(unit, week_number: 33, year: 2018)

      get path
      get path

      expect(Renalware::HD::Scheduling::WeeklyDiary.where(hospital_unit_id: unit.id).count)
        .to eq(1)
      expect(Renalware::HD::Scheduling::MasterDiary.where(hospital_unit_id: unit.id).count)
        .to eq(1)
    end
  end
end
