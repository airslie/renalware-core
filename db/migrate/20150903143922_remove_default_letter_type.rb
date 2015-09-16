class RemoveDefaultLetterType < ActiveRecord::Migration
  def change
    change_column :letters, :type, :string, default: nil
  end
end
