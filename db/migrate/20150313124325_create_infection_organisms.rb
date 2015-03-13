class CreateInfectionOrganisms < ActiveRecord::Migration
  def change
    create_table :infection_organisms do |t|
      t.integer :organism_code_id
      t.references :infectable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
