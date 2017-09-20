class AddIndexesToDiarySlots < ActiveRecord::Migration[5.1]
  def change
    # This unique index ensures that, for a diary (weekly or master), the same patient can
    # only be added to one station in any period (am pm etc) on any day of the week
    add_index :hd_diary_slots,
              [
                :diary_id,
                :diurnal_period_code_id,
                :day_of_week,
                :patient_id
              ],
              unique: true,
              name: "idx_unique_diaryslot_patients"

    add_column :hd_diary_slots, :archived, :boolean, null: false, default: false
    add_index :hd_diary_slots, :archived
    add_column :hd_diary_slots, :archived_at, :datetime
  end
end
