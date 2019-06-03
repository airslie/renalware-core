class AddColumnsToPatientPrimaryCarePhysicians < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_practice_memberships, :last_change_date, :date
    add_column :patient_practice_memberships, :joined_on, :date
    add_column :patient_practice_memberships, :left_on, :date
    add_column :patient_practice_memberships, :active, :boolean, default: true, null: false
  end
end
