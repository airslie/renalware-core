class AddEventClassToEventTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :event_types, :event_class_name, :string, null: true
  end
end
