class CreateAdmissionsRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :admission_request_reasons do |t|
      t.string :description, null: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :admission_requests do |t|
      t.references :patient, null: false, foreign_key: true
      t.integer :reason_id, null: false, index: true
      t.references :hospital_unit, foreign_key: true, index: true
      t.text :notes
      t.datetime :deleted_at, index: true
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.integer :position, null: false, default: 0, index: true
      t.timestamps null: false
    end

    # We only allow on patient with a current (deleted_at = NULL) row.
    # Indexing on [:patient_id, :deleted_at] does the trick because deleted_at is not used
    # in the if its NULL.
    add_index :admission_requests, [:patient_id, :deleted_at], unique: true
    add_foreign_key :admission_requests, :users, column: :created_by_id
    add_foreign_key :admission_requests, :users, column: :updated_by_id
    add_foreign_key :admission_requests, :admission_request_reasons, column: :reason_id
  end
end
