class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :reporting_audits do |t|
      t.string :name, null: false
      t.string :materialized_view_name, null: false
      t.datetime :refreshed_at
      t.string :refresh_schedule,
               null: false,
               default: "1 0 * * 1-6" # default is midnight Mon-Sat
      t.text :display_configuration, null: false, default: "{}"
      t.timestamps null: false
    end
  end
end
