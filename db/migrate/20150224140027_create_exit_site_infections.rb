class CreateExitSiteInfections < ActiveRecord::Migration
  def change
    create_table :exit_site_infections do |t|
      t.integer :user_id
      t.integer :patient_id
      t.date :diagnosis_date
      t.text :treatment
      t.text :outcome
      t.text :notes
      t.timestamps null: false
    end
  end
end
