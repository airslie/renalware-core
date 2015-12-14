class CreateTransplantsFailureCauseDescriptions < ActiveRecord::Migration
  def change
    create_table :transplants_failure_cause_descriptions do |t|
      t.integer :group_id
      t.string :code, null: false
      t.string :name

      t.timestamps null: false
    end

    add_index :transplants_failure_cause_descriptions, :code, unique: true
    add_foreign_key :transplants_failure_cause_descriptions,
      :transplants_failure_cause_description_groups,
      column: :group_id

  end
end
