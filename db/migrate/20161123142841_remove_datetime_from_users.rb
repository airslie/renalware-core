class RemoveDatetimeFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :datetime
  end
end
