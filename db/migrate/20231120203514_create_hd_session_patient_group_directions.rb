class CreateHDSessionPatientGroupDirections < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :hd_session_patient_group_directions do |t|
        t.references(
          :session,
          foreign_key: { to_table: :hd_sessions },
          null: false
        )
        t.references(
          :patient_group_direction,
          foreign_key: { to_table: :drug_patient_group_directions },
          index: { name: "idx_hd_session_pgds_pgd_id" },
          null: false
        )
        t.timestamps
      end
      add_index(
        :hd_session_patient_group_directions,
        [:session_id, :patient_group_direction_id],
        name: "idx_hd_session_pgds_session_pgd"
      )
    end
  end
end
