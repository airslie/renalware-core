class CreateInfectionOrganisms < ActiveRecord::Migration
  def change
    create_table :infection_organisms do |t|
      t.integer :organism_code_id
      t.integer :sensitivity_id
      t.references :infectable, polymorphic: true, index: true
      t.timestamps null: false
    end
    add_index(:infection_organisms, [:organism_code_id, :infectable_id, :infectable_type], name: "index_infection_organisms", unique: true)
  end
end
