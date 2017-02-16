class AddDefaultCCToContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :letter_contacts, :default_cc, :boolean, null: false, default: false
  end
end
