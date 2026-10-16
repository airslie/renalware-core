describe "Managing HD diary slots" do
  let(:user) { Renalware::User.first || create(:user) }
  let(:unit) { create(:hd_hospital_unit) }
  let(:station) { create(:hd_station, hospital_unit: unit) }
  let(:am) { create(:hd_diurnal_period_code, :am) }
  let(:patient) { create(:hd_patient) }
  let(:master_diary) { create(:hd_master_diary, hospital_unit: unit) }
  let(:weekly_diary) { create(:hd_weekly_diary, master_diary:, hospital_unit: unit) }

  before { create(:schedule_definition, :mon_wed_fri_am) }

  def slot_params(extra = {})
    {
      slot: {
        station_id: station.id,
        diurnal_period_code_id: am.id,
        day_of_week: 1,
        patient_id: patient.id,
        patient_search_scope: "dialysing_at_unit"
      }.merge(extra)
    }
  end

  def create_slot(diary:, **attrs)
    create(
      :hd_diary_slot,
      diary:,
      station:,
      diurnal_period_code: am,
      day_of_week: 1,
      patient:,
      by: user,
      **attrs
    )
  end

  describe "GET new" do
    it "renders the add patient form for the weekly diary" do
      get new_hd_scheduling_diary_slot_path(
        weekly_diary,
        station_id: station.id,
        diurnal_period_code_id: am.id,
        day_of_week: 1,
        format: :html
      )

      expect(response).to be_successful
      expect(response.body).to include("Add for this week only")
      expect(response.body).to include("Add to this and all future weeks")
    end
  end

  describe "GET edit" do
    it "renders the form for an existing slot" do
      slot = create_slot(diary: weekly_diary)

      get edit_hd_scheduling_diary_slot_path(weekly_diary, slot, format: :html)

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    it "adds the patient to the weekly diary for 'this week only'" do
      post hd_scheduling_diary_slots_path(weekly_diary, format: :js),
           params: slot_params,
           xhr: true

      expect(response).to be_successful
      expect(weekly_diary.slots.count).to eq(1)
      expect(master_diary.slots.count).to eq(0)
    end

    it "adds the patient to the master diary when the 'master' button was used" do
      post hd_scheduling_diary_slots_path(weekly_diary, format: :js),
           params: slot_params.merge(master: ""),
           xhr: true

      expect(response).to be_successful
      expect(master_diary.slots.count).to eq(1)
      expect(weekly_diary.slots.count).to eq(0)
    end

    it "records who made the change" do
      post hd_scheduling_diary_slots_path(weekly_diary, format: :js),
           params: slot_params,
           xhr: true

      expect(weekly_diary.slots.last.created_by).to be_present
    end

    it "re-renders the form without saving when the slot is invalid" do
      create_slot(diary: weekly_diary)
      other_patient = create(:hd_patient)

      post hd_scheduling_diary_slots_path(weekly_diary, format: :js),
           params: slot_params(patient_id: other_patient.id),
           xhr: true

      expect(Renalware::HD::Scheduling::DiarySlot.count).to eq(1)
      expect(response).to be_successful
      expect(response.body).to include("slot-form")
    end
  end

  describe "PATCH update" do
    it "changes only the arrival time" do
      slot = create_slot(diary: weekly_diary)

      patch hd_scheduling_diary_slot_path(weekly_diary, slot, format: :js),
            params: { slot: { arrival_time: "10:30", patient_id: create(:hd_patient).id } },
            xhr: true

      expect(response).to be_successful
      slot.reload
      expect(slot.arrival_time.strftime("%H:%M")).to eq("10:30")
      expect(slot.patient).to eq(patient)
    end
  end

  describe "DELETE destroy" do
    it "removes the slot" do
      slot = create_slot(diary: weekly_diary)

      delete hd_scheduling_diary_slot_path(weekly_diary, slot, format: :js), xhr: true

      expect(response).to be_successful
      expect(Renalware::HD::Scheduling::DiarySlot.exists?(slot.id)).to be(false)
    end
  end

  describe "GET refresh slot" do
    def refresh_path
      hd_scheduling_diary_refresh_slot_path(
        diary_id: weekly_diary.id,
        day_of_week: 1,
        diurnal_period_code_id: am.id,
        station_id: station.id,
        format: :js
      )
    end

    it "renders the weekly slot when there is one" do
      create_slot(diary: weekly_diary)

      get refresh_path, xhr: true

      expect(response).to be_successful
      expect(response.body).to include("data-weekly")
      expect(response.body).not_to include("data-master")
    end

    it "falls back to the master slot when there is no weekly slot" do
      create_slot(diary: master_diary)

      get refresh_path, xhr: true

      expect(response).to be_successful
      expect(response.body).to include("data-master")
    end

    it "renders an Add button when neither diary has a slot" do
      get refresh_path, xhr: true

      expect(response).to be_successful
      expect(response.body).to include("slots/new")
    end
  end
end
