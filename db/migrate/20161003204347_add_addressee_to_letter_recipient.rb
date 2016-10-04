class AddAddresseeToLetterRecipient < ActiveRecord::Migration
  def change
    add_column :letter_recipients, :addressee_type, :string
    add_column :letter_recipients, :addressee_id, :integer
    add_index :letter_recipients, [:addressee_type, :addressee_id]
  end
end
