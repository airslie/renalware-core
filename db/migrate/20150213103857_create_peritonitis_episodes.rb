class CreatePeritonitisEpisodes < ActiveRecord::Migration
  def change
    create_table :peritonitis_episodes do |t|
      
      t.timestamps null: false
    end
  end
end
