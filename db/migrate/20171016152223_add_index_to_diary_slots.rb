class AddIndexToDiarySlots < ActiveRecord::Migration[5.1]
  def change
    # Scoped to a diary, the combination of day + station + diurnal_period is unique
    add_index :hd_diary_slots,
              [:diary_id, :station_id, :day_of_week, :diurnal_period_code_id],
              name: :hd_diary_slots_unique_by_station_day_period,
              unique: true,
              where: "deleted_at IS NULL"

    # Scoped to a diary, a patient can only occur once in any combination of day + diurnal_period
    add_index :hd_diary_slots,
              [:diary_id, :day_of_week, :diurnal_period_code_id, :patient_id],
              name: :hd_diary_slots_unique_by_day_period_patient,
              unique: true,
              where: "deleted_at IS NULL"
  end
end
