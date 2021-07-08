class CreateEventSubtypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :event_subtypes do |t|
        t.references :event_type, null: false, foreign_key: true
        t.string :name, null: false
        t.text :description, null: true
        t.integer(
          :position,
          null: false,
          default: 0,
          comment: "The order of the subtype within an event type, if >1 subtypes"
        )
        t.jsonb :definition, default: "{}", null: false
        t.references :updated_by, foreign_key: { to_table: :users }, null: false
        t.references :created_by, foreign_key: { to_table: :users }, null: false
        t.timestamps null: false
        t.datetime :deactivated_at, index: true
        t.boolean :active, null: true, default: true
      end
    end
  end
end
