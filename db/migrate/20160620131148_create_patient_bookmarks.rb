class CreatePatientBookmarks < ActiveRecord::Migration
  def change
    create_table :patient_bookmarks do |t|
      t.integer :patient_id, null: false
      t.integer :user_id, null: false
    end
  end
end
