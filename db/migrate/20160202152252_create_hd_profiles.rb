class CreateHDProfiles < ActiveRecord::Migration
  def change
    create_table :hd_profiles do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.belongs_to :hospital_unit, index: true, foreign_key: true

      t.string :schedule
      t.string :other_schedule
      t.integer :prescribed_time
      t.date :prescribed_on

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :hd_profiles, :document, using: :gin

    add_reference :hd_profiles, :prescriber, references: :users, index: true
    add_foreign_key :hd_profiles, :users, column: :prescriber_id

    add_reference :hd_profiles, :named_nurse, references: :users, index: true
    add_foreign_key :hd_profiles, :users, column: :named_nurse_id

    add_reference :hd_profiles, :transport_decider, references: :users, index: true
    add_foreign_key :hd_profiles, :users, column: :transport_decider_id
  end
end
