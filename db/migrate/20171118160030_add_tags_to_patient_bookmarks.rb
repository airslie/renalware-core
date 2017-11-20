class AddTagsToPatientBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :patient_bookmarks, :tags, :string
  end
end
