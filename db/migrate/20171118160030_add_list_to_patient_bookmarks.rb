class AddListToPatientBookmarks < ActiveRecord::Migration[5.1]
  def change
    add_column :patient_bookmarks, :list, :string
  end
end
