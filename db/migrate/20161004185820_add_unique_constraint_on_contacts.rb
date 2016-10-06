class AddUniqueConstraintOnContacts < ActiveRecord::Migration
  def change
    remove_index :letter_contacts, :person_id
    remove_index :letter_contacts, :patient_id

    add_index :letter_contacts, [:person_id, :patient_id], unique: true
  end
end
