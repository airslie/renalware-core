class CreateTransplantsFailureCauseDescriptionGroups < ActiveRecord::Migration
  def change
    create_table :transplants_failure_cause_description_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
