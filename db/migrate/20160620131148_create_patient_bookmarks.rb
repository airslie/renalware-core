class CreatePatientBookmarks < ActiveRecord::Migration
  def change
    create_table :patient_bookmarks do |t|
      t.integer :patient_id, null: false, foreign_key: true, unique: true
      t.integer :user_id, null: false, foreign_key: true, unique: true
    end
  end
end
