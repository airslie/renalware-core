class CreateInfectionOrganisms < ActiveRecord::Migration
  def change
    create_table :infection_organisms do |t|
      t.references :organism_code, null: false, foreign_key: true
      t.text :sensitivity
      t.references :infectable,    polymorphic: true, index: true
      t.timestamps null: false
    end
    add_index(:infection_organisms, [:organism_code_id, :infectable_id, :infectable_type],
      name: "index_infection_organisms", unique: true)
  end
end
