class RenameAccessPlansToAccessPlanTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :access_profiles, :plan_id
    remove_column :access_profiles, :planned_on

    rename_table :access_plans, :access_plan_types

    create_table :access_plans do |t|
      t.integer :plan_type_id, null: false, index: true
      t.text :notes
      t.integer :patient_id, null: false, index: true
      t.integer :decided_by_id, index: true
      t.integer :updated_by_id, null: false, index: true
      t.integer :created_by_id, null: false, index: true
      t.datetime :terminated_at, index: true
      t.timestamps null: false
    end

    add_foreign_key :access_plans, :access_plan_types, column: :plan_type_id
    add_foreign_key :access_plans, :patients, column: :patient_id
    add_foreign_key :access_plans, :users, column: :decided_by_id
    add_foreign_key :access_plans, :users, column: :created_by_id
    add_foreign_key :access_plans, :users, column: :updated_by_id

    # There can only ever be one un-terminated plan per user - is the current one
    ActiveRecord::Base.connection.execute(
      "CREATE UNIQUE INDEX access_plan_uniqueness ON access_plans
      (patient_id, COALESCE(terminated_at, '1970-01-01'));"
    )
  end
end
