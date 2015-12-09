class CreateTransplantsRecipientFollowups < ActiveRecord::Migration
  def change
    create_table :transplants_recipient_followups do |t|
      t.integer :operation_id
      t.text :notes

      t.date :stent_removed_on
      t.boolean :transplant_failed
      t.date :transplant_failed_on
      t.string :transplant_failure_cause_code
      t.string :transplant_failure_cause_other
      t.text :transplant_failure_notes

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_recipient_followups, :operation_id
    add_index :transplants_recipient_followups, :document, using: :gin

    add_foreign_key :transplants_recipient_followups, :transplants_failure_cause_descriptions,
      column: :transplant_failure_cause_code, primary_key: :code
  end
end
