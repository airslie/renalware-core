class RemoveUserFromAppointments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      remove_column :clinic_appointments, :user_id, :integer

      add_reference :clinic_appointments,
                    :updated_by,
                    foreign_key: { to_table: :users },
                    index: true,
                    null: true

      add_reference :clinic_appointments,
                    :created_by,
                    foreign_key: { to_table: :users },
                    index: true,
                    null: true
    end
  end
end
