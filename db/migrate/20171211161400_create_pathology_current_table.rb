class CreatePathologyCurrentTable < ActiveRecord::Migration[5.1]
  def change
    create_table :pathology_current_observation_sets do |t|
      t.references :patient, null: false, foreign_key: true, index: true
      t.jsonb :values, index: { using: :gin }, default: {}

      t.timestamps null: false
    end
  end
end
