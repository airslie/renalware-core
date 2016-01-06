class CreateTransplantsDonorFollowups < ActiveRecord::Migration
  def change
    create_table :transplants_donor_followups do |t|
      t.integer :operation_id
      t.text :notes

      t.date :last_seen_on
      t.boolean :followed_up
      t.string :ukt_center_code

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_donor_followups, :operation_id
    add_index :transplants_donor_followups, :document, using: :gin

    add_foreign_key :transplants_donor_followups, :transplants_donor_operations,
      column: :operation_id
  end
end
