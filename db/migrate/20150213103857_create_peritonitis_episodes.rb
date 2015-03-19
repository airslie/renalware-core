class CreatePeritonitisEpisodes < ActiveRecord::Migration
  def change
    create_table :peritonitis_episodes do |t|
      t.integer :user_id
      t.integer :patient_id
      t.date :diagnosis_date
      t.date :start_treatment_date
      t.date :end_treatment_date
      t.integer :episode_type_id
      t.boolean :catheter_removed
      t.boolean :line_break
      t.boolean :exit_site_infection
      t.boolean :diarrhoea
      t.boolean :abdominal_pain
      t.integer :fluid_description_id
      t.integer :white_cell_total
      t.integer :white_cell_neutro
      t.integer :white_cell_lympho
      t.integer :white_cell_degen
      t.integer :white_cell_other
      t.text :notes
      t.timestamps null: false
    end
  end
end
