class AddTagsToPatientBookmarks < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :patient_bookmarks, :tags, :string
    end
  end
end
