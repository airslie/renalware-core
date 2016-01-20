class CreateAccessesDescriptions < ActiveRecord::Migration
  def change
    create_table :access_descriptions do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
