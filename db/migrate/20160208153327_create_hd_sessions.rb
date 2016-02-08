class CreateHDSessions < ActiveRecord::Migration
  def change
    create_table :hd_sessions do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.belongs_to :hospital_unit, index: true, foreign_key: true
      t.belongs_to :modality_description, index: true, foreign_key: true

      t.date :performed_on, null: false
      t.time :start_time, null: false
      t.time :end_time
      t.integer :duration
      t.text :notes

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :hd_sessions, :document, using: :gin

    add_reference :hd_sessions, :signed_on_by, references: :users, index: true
    add_foreign_key :hd_sessions, :users, column: :signed_on_by_id

    add_reference :hd_sessions, :signed_off_by, references: :users, index: true
    add_foreign_key :hd_sessions, :users, column: :signed_off_by_id
  end
end
