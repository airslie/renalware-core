class CreateDonorStageStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :transplant_donor_stage_statuses do |t|
      t.string :name, null: false
      t.integer :position, null: false, index: true, default: 1
      t.timestamps null: false
    end

    add_index :transplant_donor_stage_statuses,
              :name,
              unique: true
  end
end
