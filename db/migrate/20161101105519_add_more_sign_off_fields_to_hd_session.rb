class AddMoreSignOffFieldsToHDSession < ActiveRecord::Migration
  def change
    add_reference :hd_sessions, :hd_profile, references: :hd_profiles, index: true
    add_foreign_key :hd_sessions, :hd_profiles, column: :hd_profile_id

    add_reference :hd_sessions, :hd_dry_weight, references: :hd_dry_weights, index: true
    add_foreign_key :hd_sessions, :hd_dry_weights, column: :hd_dry_weight_id
  end
end
