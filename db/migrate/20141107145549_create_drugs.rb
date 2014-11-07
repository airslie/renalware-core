class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|

      t.timestamps
    end
  end
end
