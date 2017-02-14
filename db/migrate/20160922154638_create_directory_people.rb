class CreateDirectoryPeople < ActiveRecord::Migration[4.2]
  def change
    create_table :directory_people do |t|
      t.string :given_name, null: false
      t.string :family_name, null: false
      t.string :title

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end
  end
end
