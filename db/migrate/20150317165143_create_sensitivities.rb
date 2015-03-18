class CreateSensitivities < ActiveRecord::Migration
  def change
    create_table :sensitivities do |t|
      t.text :notes
      t.timestamps null: false
    end
  end
end
