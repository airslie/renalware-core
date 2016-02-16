class CreateAccessProcedures < ActiveRecord::Migration
  def change
    create_table :access_procedures do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.references :type, null: false
      t.references :site, null: false
      t.string :side, null: false
      t.date :performed_on, null: false

      t.boolean :first_procedure
      t.string :catheter_make
      t.string :catheter_lot_no
      t.text :outcome
      t.text :notes
      t.date :first_used_on
      t.date :failed_on

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_reference :access_procedures, :performed_by, references: :users, index: true, null: false
    add_foreign_key :access_procedures, :users, column: :performed_by_id

    add_foreign_key :access_procedures, :access_types, column: :type_id
    add_foreign_key :access_procedures, :access_sites, column: :site_id
  end
end
