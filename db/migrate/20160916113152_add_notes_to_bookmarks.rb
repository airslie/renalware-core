class AddNotesToBookmarks < ActiveRecord::Migration[4.2]
  def change
    add_column :patient_bookmarks, :notes, :text
    add_column :patient_bookmarks, :urgent, :boolean, default: false, null: false, index: true
  end
end
