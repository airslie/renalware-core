class AddColsToHDPatientStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_patient_statistics,
               :pathology_snapshot,
               :jsonb,
               index: { using: :gin },
               default: "'{}'::jsonb",
               null: false
  end
end
