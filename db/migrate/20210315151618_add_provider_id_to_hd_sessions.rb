class AddProviderIdToHDSessions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference(
        :hd_sessions,
        :provider,
        foreign_key: { to_table: :hd_providers },
        index: true,
        null: true
      )

      add_column(:hd_sessions, :machine_ip_address, :string)
    end
  end
end
