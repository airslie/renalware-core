class CreateLetterSectionSnapshots < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :letter_section_snapshots do |t|
        t.references :letter, null: false, foreign_key: { to_table: :letter_letters }, index: true
        t.string :section_identifier
        t.string :content

        t.timestamps
      end
    end
  end
end
