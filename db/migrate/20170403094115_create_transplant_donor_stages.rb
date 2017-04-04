class CreateTransplantDonorStages < ActiveRecord::Migration[5.0]
  def change
    create_table :transplant_donor_stages do |t|
      t.references :patient, null: false, foreign_key: true, index: true
      t.integer :stage_position_id,
                null: false,
                index: { name: "tx_donor_stage_position_idx" }
      t.integer :stage_status_id,
                null: false,
                index: { name: "tx_donor_stage_status_idx" }
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false
      t.datetime :started_on, null: false
      t.datetime :terminated_on, null: true
      t.text :notes
      t.timestamps null: false
    end

    add_foreign_key :transplant_donor_stages,
                    :transplant_donor_stage_positions,
                    column: :stage_position_id
    add_foreign_key :transplant_donor_stages,
                    :transplant_donor_stage_statuses,
                    column: :stage_status_id
    add_foreign_key :transplant_donor_stages, :users, column: :created_by_id
    add_foreign_key :transplant_donor_stages, :users, column: :updated_by_id
  end
end
