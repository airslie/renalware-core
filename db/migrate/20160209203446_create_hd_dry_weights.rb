class CreateHDDryWeights < ActiveRecord::Migration
  def change
    create_table :hd_dry_weights do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.float :weight, null: false
      t.date :assessed_on, null: false

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_reference :hd_dry_weights, :assessor, references: :users, index: true, null: false
    add_foreign_key :hd_dry_weights, :users, column: :assessor_id
  end
end
