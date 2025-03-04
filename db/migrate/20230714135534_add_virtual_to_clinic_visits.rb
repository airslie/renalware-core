class AddVirtualToClinicVisits < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        create_table(:clinic_visit_locations) do |t|
          t.string :name, null: false, index: { unique: true }
          t.boolean(
            :default_location,
            default: false,
            null: false,
            index: {
              unique: true,
              where: "default_location = true and deleted_at is null"
            }
          )
          t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
          t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
          t.datetime :deleted_at, index: true
          t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
        end
        add_reference(
          :clinic_visits,
          :location,
          foreign_key: { to_table: :clinic_visit_locations },
          index: true
        )
      end
    end
  end
end
