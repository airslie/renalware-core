class CreateFeedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_files do |t|
      t.integer :file_type_id, null: false, index: true
      t.string :location, null: false
      t.integer :status, null: false, default: 0
      t.text :result
      t.integer :time_taken, null: true
      t.integer :attempts, null: false, default: 0
      t.timestamps null: false

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: true
    end

    add_foreign_key :feed_files,
                    :feed_file_types,
                    column: :file_type_id
  end
end
