class CreateUserFeedback < ActiveRecord::Migration[5.1]
  def change
    create_table :system_user_feedback do |t|
      t.references :author, foreign_key: { to_table: :users }, index: true, null: false
      t.string :category, index: true, null: false
      t.text :comment, null: false
      t.timestamps null: false
    end
  end
end
