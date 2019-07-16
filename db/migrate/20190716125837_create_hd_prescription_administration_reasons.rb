class CreateHDPrescriptionAdministrationReasons < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :hd_prescription_administration_reasons do |t|
        t.string :name, null: false, index: { unique: true }
        t.timestamps null: false
      end

      add_reference(
        :hd_prescription_administrations,
        :reason,
        foreign_key: { to_table: :hd_prescription_administration_reasons },
        index: true
      )
    end
  end
end
