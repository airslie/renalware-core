class CreateEthnicities < ActiveRecord::Migration
  def change
    create_table :patient_ethnicities do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
