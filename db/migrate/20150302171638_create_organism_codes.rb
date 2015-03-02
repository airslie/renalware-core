class CreateOrganismCodes < ActiveRecord::Migration
  def change
    create_table :organism_codes do |t|

      t.timestamps null: false
    end
  end
end
