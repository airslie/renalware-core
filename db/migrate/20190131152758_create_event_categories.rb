class CreateEventCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :event_categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :position, null: false, default: 10
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    add_reference(
      :event_types,
      :category,
      references: :event_categories,
      index: true,
      null: true,
      foreign_key: { to_table: :event_categories }
    )
  end
end
