class CreateTransplantsDonorOperations < ActiveRecord::Migration
  def change
    create_table :transplants_donor_operations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.date :performed_on, null: false
      t.string :anaesthetist
      t.string :donor_splenectomy_peri_or_post_operatively
      t.string :kidney_side
      t.string :nephrectomy_type
      t.string :nephrectomy_type_other
      t.string :operating_surgeon
      t.text :notes

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_donor_operations, :document, using: :gin
  end
end
