class AddSlugToEventTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :event_types, :slug, :string
    add_index :event_types, :slug, unique: true
  end
end
