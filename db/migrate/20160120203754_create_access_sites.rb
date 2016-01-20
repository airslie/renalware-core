class CreateAccessSites < ActiveRecord::Migration
  def change
    create_table :access_sites do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
