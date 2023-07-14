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
              where: "default_location = true"
            }
          )
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
