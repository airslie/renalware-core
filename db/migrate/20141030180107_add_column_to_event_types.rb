class AddColumnToEventTypes < ActiveRecord::Migration
  def change
    add_column :event_types, :name, :string
  end
end
