class AddColumnsToSupportDataMigration < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :admission_admissions, :feed_id, :string, index: true
      add_column :clinic_appointments, :feed_id, :string, index: true
      add_reference(
        :clinic_appointments,
        :consultant,
        index: true,
        foreign_key: { to_table: :renal_consultants }
      )
      add_column :clinic_appointments, :clinic_description, :text
    end
  end
end
