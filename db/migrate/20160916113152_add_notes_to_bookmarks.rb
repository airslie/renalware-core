class AddNotesToBookmarks < ActiveRecord::Migration
  def change
    add_column :patient_bookmarks, :notes, :text
    add_column :patient_bookmarks, :urgent, :boolean, default: false, null: false, index: true
  end
end
