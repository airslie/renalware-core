class CreateSnippets < ActiveRecord::Migration[5.0]
  def change
    create_table :snippets_snippets do |t|
      t.string :title, null: false, index: :unique
      t.text :body, null: false
      t.datetime :last_used_on, null: true
      t.integer :times_used, null: false, default: 0
      t.integer :author_id, null: false, index: true
      t.timestamps null: false
    end

    add_foreign_key :snippets_snippets, :users, column: :author_id
  end
end
