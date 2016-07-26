class CreateOrganismCodes < ActiveRecord::Migration
  def change
    create_table :pd_organism_codes do |t|
      t.string :read_code
      t.string :name
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
