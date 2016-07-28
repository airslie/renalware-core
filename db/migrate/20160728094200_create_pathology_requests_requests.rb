class CreatePathologyRequestsRequests < ActiveRecord::Migration
  def change
    create_table :pathology_requests_requests do |t|
      t.integer :patient_id, null: false
      t.integer :clinic_id, null: false
      t.integer :consultant_id, null: false
      t.string :telephone, null: false
      t.integer :created_by_id, null: false
      t.integer :updated_by_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :pathology_requests_requests, :patients, column: :patient_id
    add_foreign_key :pathology_requests_requests, :clinics, column: :clinic_id
    add_foreign_key :pathology_requests_requests, :users, column: :consultant_id
  end
end
