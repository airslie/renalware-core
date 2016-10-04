class CreateRenalwareLettersContacts < ActiveRecord::Migration
  def change
    create_table :letter_contacts do |t|
      t.references :patient, index: true, null: false
      t.references :person, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :letter_contacts, :patients, column: :patient_id
    add_foreign_key :letter_contacts, :directory_people, column: :person_id
  end
end
