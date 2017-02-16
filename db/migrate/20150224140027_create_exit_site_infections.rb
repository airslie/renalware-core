class CreateExitSiteInfections < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_exit_site_infections do |t|
      t.references :patient,  null: false, foreign_key: true
      t.date :diagnosis_date, null: false
      t.text :treatment
      t.text :outcome
      t.text :notes
      t.timestamps null: false
    end
  end
end
