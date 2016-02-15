class CreateAccessAccesses < ActiveRecord::Migration
  def change
    create_table :access_accesses do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.date :formed_on, null: false
      t.date :planned_on
      t.date :started_on
      t.date :terminated_on
      t.references :type, null: false
      t.references :site, null: false
      t.references :plan
      t.string :side, null: false
      t.text :notes

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_reference :access_accesses, :decided_by, references: :users, index: true
    add_foreign_key :access_accesses, :users, column: :decided_by_id

    add_foreign_key :access_accesses, :access_types, column: :type_id
    add_foreign_key :access_accesses, :access_sites, column: :site_id
    add_foreign_key :access_accesses, :access_plans, column: :plan_id
  end
end
