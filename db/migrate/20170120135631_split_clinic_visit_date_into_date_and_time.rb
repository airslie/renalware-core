class SplitClinicVisitDateIntoDateAndTime < ActiveRecord::Migration
  def change
    change_column :clinic_visits, :date, :date, null: false
    add_column :clinic_visits, :time, :time, null: true
  end
end
