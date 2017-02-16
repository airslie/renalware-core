class CreatePeritonitisEpisodes < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_peritonitis_episodes do |t|
      t.references :patient,           null: false, foreign_key: true
      t.date :diagnosis_date,          null: false
      t.date :treatment_start_date
      t.date :treatment_end_date
      t.references :episode_type, index: true
      t.boolean :catheter_removed
      t.boolean :line_break
      t.boolean :exit_site_infection
      t.boolean :diarrhoea
      t.boolean :abdominal_pain
      t.references :fluid_description, index: true
      t.integer :white_cell_total
      t.integer :white_cell_neutro
      t.integer :white_cell_lympho
      t.integer :white_cell_degen
      t.integer :white_cell_other
      t.text :notes
      t.timestamps null: false
    end

    add_foreign_key :pd_peritonitis_episodes, :pd_fluid_descriptions, column: :fluid_description_id
    add_foreign_key :pd_peritonitis_episodes, :pd_episode_types, column: :episode_type_id
  end
end
