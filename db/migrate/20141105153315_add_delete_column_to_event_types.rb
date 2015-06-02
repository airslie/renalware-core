class AddDeleteColumnToEventTypes < ActiveRecord::Migration
  def change
    add_column :event_types, :deleted_at, :datetime
  end
end
