class AddMoreSignOffFieldsToHDSession < ActiveRecord::Migration[4.2]
  def change
    add_reference :hd_sessions, :profile, references: :hd_profiles, index: true
    add_foreign_key :hd_sessions, :hd_profiles, column: :profile_id

    add_reference :hd_sessions, :dry_weight, references: :hd_dry_weights, index: true
    add_foreign_key :hd_sessions, :hd_dry_weights, column: :dry_weight_id
  end
end
