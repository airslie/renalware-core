class CreateEpisodeTypes < ActiveRecord::Migration
  def change
    create_table :episode_types do |t|
      t.string :term
      t.string :definition
      t.datetime :deleted_at 
      t.timestamps null: false
    end
  end
end
