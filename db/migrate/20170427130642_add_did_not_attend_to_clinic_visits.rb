class AddDidNotAttendToClinicVisits < ActiveRecord::Migration[5.0]
  def change
    add_column :clinic_visits, :did_not_attend, :boolean, null: false, default: false
  end
end
