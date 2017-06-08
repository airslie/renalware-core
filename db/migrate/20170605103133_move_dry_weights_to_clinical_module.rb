class MoveDryWeightsToClinicalModule < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :hd_dry_weights, :users
    rename_table :hd_dry_weights, :clinical_dry_weights
    add_foreign_key :clinical_dry_weights, :users, column: :assessor_id
  end
end
