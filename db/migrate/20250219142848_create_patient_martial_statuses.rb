class CreatePatientMartialStatuses < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :patient_marital_statuses do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false
        t.timestamps null: false
      end

      # Will block patients writes!
      safety_assured do
        add_reference(
          :patients,
          :marital_status,
          foreign_key: { to_table: :patient_marital_statuses },
          index: true
        )
      end
    end
  end
end
