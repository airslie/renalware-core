# rubocop:disable Rails/CreateTableWithTimestamps
class CreateSystemVisitsAndEvents < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :system_visits do |t|
        t.string :visit_token
        t.string :visitor_token

        # the rest are recommended but optional
        # simply remove any you don't want

        # user
        t.references :user, index: true

        # standard
        t.string :ip
        t.text :user_agent
        t.text :referrer
        t.string :referring_domain
        t.string :search_keyword
        t.text :landing_page

        # technology
        t.string :browser
        t.string :os
        t.string :device_type

        t.timestamp :started_at
      end

      add_index :system_visits, [:visit_token], unique: true

      create_table :system_events do |t|
        t.references :visit
        t.references :user, index: true
        t.timestamp :time

        t.string :name
        t.jsonb :properties
      end

      add_index :system_events, [:name, :time]
      add_index :system_events, "properties jsonb_path_ops", using: "gin"
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
