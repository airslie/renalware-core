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
      t.timestamps null: false
    end
  end
end
