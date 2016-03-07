class RemoveDefaultLetterType < ActiveRecord::Migration
  def change
    change_column :letter_letters, :type, :string, default: nil
  end
end
