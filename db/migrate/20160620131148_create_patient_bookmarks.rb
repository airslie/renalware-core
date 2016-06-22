class CreatePatientBookmarks < ActiveRecord::Migration
  def change
    create_table :patient_bookmarks do |t|
      t.integer :patient_id, null: false, foreign_key: true
      t.integer :user_id, null: false, foreign_key: true
    end

    add_index(:patient_bookmarks, [:patient_id, :user_id], unique: true)
  end
end
