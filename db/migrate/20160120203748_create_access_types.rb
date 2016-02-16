class CreateAccessTypes < ActiveRecord::Migration
  def change
    create_table :access_types do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
