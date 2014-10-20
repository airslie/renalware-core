class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|

      t.timestamps
    end
  end
end
