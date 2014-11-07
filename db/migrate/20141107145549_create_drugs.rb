class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :type
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
