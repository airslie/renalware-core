class CreateHDDialysers < ActiveRecord::Migration
  def change
    create_table :hd_dialysers do |t|
      t.string :group, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
