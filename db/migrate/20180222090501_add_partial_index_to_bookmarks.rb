class AddPartialIndexToBookmarks < ActiveRecord::Migration[5.1]
  def change
    remove_index :patient_bookmarks, :deleted_at
    add_index :patient_bookmarks, :deleted_at, where: "deleted_at IS NULL"
  end
end
