class CreateLettersElectronicReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :letter_electronic_receipts do |t|
      t.references :letter, index: true, null: false, foreign_key: { to_table: :letter_letters }
      t.references :recipient, index: true, null: false, foreign_key: { to_table: :users }
      t.datetime :read_at, null: true, index: true
    end
  end
end
