class CreateExitSiteInfections < ActiveRecord::Migration
  def change
    create_table :exit_site_infections do |t|
      t.integer :user_id
      t.date :diagnosis_date
      t.integer :organism_1_id
      t.integer :organism_2_id
      t.text :treatment
      t.text :outcome
      t.text :notes
      t.integer :antibiotic_1_id
      t.integer :antibiotic_2_id
      t.integer :antibiotic_3_id
      t.integer :antibiotic_1_route
      t.integer :antibiotic_2_route
      t.integer :antibiotic_3_route
      t.text :sensitivities
      t.timestamps null: false
    end
  end
end
