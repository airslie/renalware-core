class CreatePathologyObservations < ActiveRecord::Migration
  def change
    create_table :pathology_observations do |t|
      t.string :result
      t.text :comment
      t.datetime :observed_at

      t.timestamps null: false
    end

    add_reference :pathology_observations, :description, references: :pathology_observation_descriptions, index: true
    add_foreign_key :pathology_observations, :pathology_observation_descriptions, column: :description_id

    add_reference :pathology_observations, :request, references: :pathology_observation_requests, index: true
    add_foreign_key :pathology_observations, :pathology_observation_requests, column: :request_id
  end
end
