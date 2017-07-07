class RenameAccessPlansToAccessPlanTypes < ActiveRecord::Migration[5.0]
  def change
    rename_table :access_plans, :access_plan_types
    create_table :access_plans do |t|
      t.integer :type_id, null: false, index: true
      t.text :notes
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    add_foreign_key :access_plans, :users, column: :created_by_id
    add_foreign_key :access_plans, :users, column: :updated_by_id
  end
end
