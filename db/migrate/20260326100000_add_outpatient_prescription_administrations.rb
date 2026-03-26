class AddOutpatientPrescriptionAdministrations < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_prescriptions,
               :give_as_outpatient,
               :boolean,
               default: false,
               null: false

    create_table :medication_outpatient_prescription_administration_reasons do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :medication_outpatient_prescription_administration_reasons,
              :name,
              unique: true,
              name: "index_outpatient_prescription_administration_reasons_on_name"

    create_table :medication_outpatient_prescription_administrations do |t|
      t.boolean :administered
      t.references :administered_by, foreign_key: { to_table: :users }, type: :bigint
      t.boolean :administrator_authorised, default: false, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :integer
      t.datetime :deleted_at
      t.references :patient, null: false, foreign_key: true, type: :bigint
      t.references :prescription,
                   null: false,
                   foreign_key: { to_table: :medication_prescriptions },
                   type: :integer
      t.references :reason,
                   foreign_key: {
                     to_table: :medication_outpatient_prescription_administration_reasons
                   },
                   type: :bigint
      t.date :recorded_on
      t.datetime :signed_off_at
      t.text :notes
      t.references :updated_by, null: false, foreign_key: { to_table: :users }, type: :integer
      t.boolean :witness_authorised, default: false, null: false
      t.references :witnessed_by, foreign_key: { to_table: :users }, type: :bigint
      t.timestamps null: false
    end

    add_index :medication_outpatient_prescription_administrations,
              :deleted_at,
              name: "index_outpatient_prescription_administrations_on_deleted_at"
  end
end
