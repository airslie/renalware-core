class CreateSensitivities < ActiveRecord::Migration
  def change
    create_table :sensitivities do |t|

      t.timestamps null: false
    end
  end
end
