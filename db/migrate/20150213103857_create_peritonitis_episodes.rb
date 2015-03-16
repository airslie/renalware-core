class CreatePeritonitisEpisodes < ActiveRecord::Migration
  def change
    create_table :peritonitis_episodes do |t|
      t.integer :user_id
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
      t.integer :organism_1_id
      t.integer :organism_2_id
      t.text :notes
      t.integer :antibiotic_1_id
      t.integer :antibiotic_2_id
      t.integer :antibiotic_3_id
      t.integer :antibiotic_4_id
      t.integer :antibiotic_5_id
      t.integer :antibiotic_1_route
      t.integer :antibiotic_2_route
      t.integer :antibiotic_3_route
      t.integer :antibiotic_4_route
      t.integer :antibiotic_5_route
      t.text :sensitivities
      t.timestamps null: false
    end
  end
end
