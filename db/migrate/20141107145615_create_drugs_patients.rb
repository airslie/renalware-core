class CreateDrugsPatients < ActiveRecord::Migration
  def change
    create_table :drugs_patients do |t|

      t.timestamps
    end
  end
end
