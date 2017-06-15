class CreateFeedFileTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_file_types do |t|
      t.string :name, index: true, null: false
      t.text :description, null: false
      t.text :prompt, null: false
      t.string :download_url_title, null: true
      t.string :download_url, null: true
      t.string :filename_validation_pattern, null: false, default: ".*"
      t.boolean :enabled, null: false, default: true

      t.timestamps null: false
    end
  end
end
