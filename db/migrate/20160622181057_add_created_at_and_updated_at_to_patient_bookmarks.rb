class AddCreatedAtAndUpdatedAtToPatientBookmarks < ActiveRecord::Migration
  def change
    change_table :patient_bookmarks do |t|
      t.timestamps
    end
  end
end
