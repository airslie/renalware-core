class CreatePatientBookmarks < ActiveRecord::Migration
  def change
    create_table :patient_bookmarks do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps null: false
    end

    add_index(:patient_bookmarks, [:patient_id, :user_id], unique: true)
  end
end
