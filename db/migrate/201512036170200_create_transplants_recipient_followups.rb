class CreateTransplantsRecipientFollowups < ActiveRecord::Migration
  def change
    create_table :transplants_recipient_followups do |t|
      t.integer :operation_id
      t.text :notes
      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_recipient_followups, :operation_id
    add_index :transplants_recipient_followups, :document, using: :gin
  end
end
