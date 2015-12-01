class CreateExitSiteInfections < ActiveRecord::Migration
  def change
    create_table :exit_site_infections do |t|
      t.references :patient,  null: false, foreign_key: true
      t.date :diagnosis_date, null: false
      t.text :treatment
      t.text :outcome
      t.text :notes
      t.timestamps null: false
    end
  end
end
