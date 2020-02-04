class AlterHDPrescriptionAdministrations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # Allow HD session if to be null, now that we are allowing HD drugs to be
      # administered before the HD session is created, so there may be no
      # associated session
      change_column_null :hd_prescription_administrations, :hd_session_id, true
      add_reference(
        :hd_prescription_administrations,
        :patient,
        foreign_key: { to_table: :patients },
        index: true,
        null: true # old data will not have one
      )
      add_column :hd_prescription_administrations, :recorded_on, :date, null: true
    end
  end
end
