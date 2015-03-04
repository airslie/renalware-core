class CreateAntibiotics < ActiveRecord::Migration
  def change
    create_table :antibiotics do |t|

      t.timestamps null: false
    end
  end
end
