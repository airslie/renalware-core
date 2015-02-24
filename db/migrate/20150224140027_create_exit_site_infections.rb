class CreateExitSiteInfections < ActiveRecord::Migration
  def change
    create_table :exit_site_infections do |t|
      t.integer :patient_id
      t.integer :user_id
      t.date :infection_date
      t.integer :organism_1
      t.integer :organism_2
      t.text :treatment
      t.text :outcome
      t.text :notes
      t.integer :antibiotic_1
      t.integer :antibiotic_2
      t.integer :antibiotic_3
      t.integer :antibiotic_1_route
      t.integer :antibiotic_2_route
      t.integer :antibiotic_3_route
      t.text :sensitivities
      t.timestamps null: false
    end
  end
end
