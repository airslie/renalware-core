# The pathology_current_observation_sets table has a values hash (jsonb)
# of the most recent pathology.
#
# You can refresh the content of this table with the following query:
#   select refresh_current_observation_set(id) from patients;

class CreatePathologyCurrentTable < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :pathology_current_observation_sets do |t|
        t.references :patient, null: false, foreign_key: true, index: { unique: true }
        t.jsonb :values, index: { using: :gin }, default: {}

        t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
        t.datetime :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      end

      drop_view :pathology_current_key_observation_sets, revert_to_version: 2
    end
  end
end
