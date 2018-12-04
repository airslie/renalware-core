class DisableSomeAudits < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :reporting_audits, :enabled, :boolean, null: false, default: true
      connection.execute(
        "update reporting_audits set enabled = false where name in ('Bone', 'Anaemia');"
      )
    end
  end
end
