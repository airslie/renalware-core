class AddNotesToLetterContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :letter_contacts, :notes, :text
  end
end
