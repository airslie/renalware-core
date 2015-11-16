class CreateTransplantsRecipientOperations < ActiveRecord::Migration
  def change
    create_table :transplants_recipient_operations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.date :performed_on, null: false
      t.time :theatre_case_start_time, null: false
      t.datetime :donor_kidney_removed_from_ice_at, null: false
      t.string :operation_type, null: false
      t.string :transplant_site, null: false
      t.datetime :kidney_perfused_with_blood_at, null: false
      t.time :cold_ischaemic_time, null: false
      t.text :notes

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_recipient_operations, :document, using: :gin
  end
end
