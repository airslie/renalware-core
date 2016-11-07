class AddNotesToLetterContacts < ActiveRecord::Migration
  def change
    add_column :letter_contacts, :notes, :text
  end
end
