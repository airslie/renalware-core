class AddDefaultCCToContacts < ActiveRecord::Migration
  def change
    add_column :letter_contacts, :default_cc, :boolean, null: false, default: false
  end
end
