class AddEventTypeIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :event_type_id, :integer
    remove_column :events, :event_type, :string
  end
end
