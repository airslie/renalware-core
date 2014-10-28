class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :date, :datetime
    add_column :events, :user_id, :string
    add_column :events, :type, :string
    add_column :events, :description, :string
    add_column :events, :notes, :text
  end
end
