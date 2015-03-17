class CreateEpisodeTypes < ActiveRecord::Migration
  def change
    create_table :episode_types do |t|
      t.string :description
      t.datetime :deleted_at 
      t.timestamps null: false
    end
  end
end
