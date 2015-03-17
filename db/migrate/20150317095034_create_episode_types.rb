class CreateEpisodeTypes < ActiveRecord::Migration
  def change
    create_table :episode_types do |t|
      t.string :description
      t.timestamps null: false
    end
  end
end
