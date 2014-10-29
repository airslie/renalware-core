class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date
      t.string :user_id
      t.string :type
      t.string :description
      t.text :notes
      t.timestamps
    end
  end
end
