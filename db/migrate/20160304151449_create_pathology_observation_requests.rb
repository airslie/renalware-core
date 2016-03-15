class CreatePathologyObservationRequests < ActiveRecord::Migration
  def change
    create_table :pathology_observation_requests do |t|
      t.string :pcs_code
      t.string :requestor_name
      t.datetime :observed_at
      t.belongs_to :patient, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :pathology_observation_requests, :description, references: :pathology_request_descriptions, index: true, null: false
    add_foreign_key :pathology_observation_requests, :pathology_request_descriptions, column: :description_id
  end
end
