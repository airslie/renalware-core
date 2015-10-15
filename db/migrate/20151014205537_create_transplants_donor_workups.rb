class CreateTransplantsDonorWorkups < ActiveRecord::Migration
  def change
    create_table :transplants_donor_workups do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_donor_workups, :document, using: :gin
  end
end
