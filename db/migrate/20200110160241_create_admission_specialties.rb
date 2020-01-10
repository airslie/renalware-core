class CreateAdmissionSpecialties < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :admission_specialties do |t|
        t.string :name, null: false, index: { unique: true }
        t.integer :position, null: false, default: 0
        t.timestamps null: false
      end

      add_reference(
        :admission_consults,
        :specialty,
        foreign_key: { to_table: :admission_specialties },
        index: true,
        null: true
      )
    end
  end
end
