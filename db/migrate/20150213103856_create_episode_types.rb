class CreateEpisodeTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_episode_types do |t|
      t.string :term
      t.string :definition
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
