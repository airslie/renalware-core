class AddAuthenticationToHDPrescriptionAdministrations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference :hd_prescription_administrations,
                    :administered_by,
                    foreign_key: { to_table: :users },
                    index: true,
                    null: true
      add_reference :hd_prescription_administrations,
                    :witnessed_by,
                    foreign_key: { to_table: :users },
                    index: true,
                    null: true
    end
  end
end
