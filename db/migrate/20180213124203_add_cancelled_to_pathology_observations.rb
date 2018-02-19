class AddCancelledToPathologyObservations < ActiveRecord::Migration[5.1]
  def change
    add_column :pathology_observations,
               :cancelled,
               :boolean,
               null: true,
               index: true
  end
end
