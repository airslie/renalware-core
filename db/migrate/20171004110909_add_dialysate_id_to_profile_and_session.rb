class AddDialysateIdToProfileAndSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :hd_profiles, :dialysate, references: :hd_dialysates, index: true
    add_foreign_key :hd_profiles, :hd_dialysates, column: :dialysate_id

    add_reference :hd_sessions, :dialysate, references: :hd_dialysates, index: true
    add_foreign_key :hd_sessions, :hd_dialysates, column: :dialysate_id
  end
end
