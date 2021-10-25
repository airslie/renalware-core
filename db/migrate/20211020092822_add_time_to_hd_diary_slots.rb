class AddTimeToHDDiarySlots < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :hd_diary_slots, :arrival_time, :time
    end
  end
end
