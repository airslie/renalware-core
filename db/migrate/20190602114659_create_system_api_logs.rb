class CreateSystemAPILogs < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :system_api_logs do |t|
        t.string :identifier, null: false, index: true
        t.string :status, null: false, index: true
        t.integer :records_added, null: false, default: 0
        t.integer :records_updated, null: false, default: 0
        t.boolean :dry_run, null: false, default: false
        t.text :error
        t.timestamps null: false
      end
    end
  end
end
