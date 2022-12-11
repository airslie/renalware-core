class AddOnlineReferencesToLetterLetters < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :letter_qr_encoded_online_reference_links do |t|
        t.references(
          :letter,
          foreign_key: { to_table: :letter_letters },
          null: false,
          index: false
        )
        t.references(
          :online_reference_link,
          foreign_key: { to_table: :system_online_reference_links },
          null: false,
          index: false
        )
        t.index(
          [:letter_id, :online_reference_link_id],
          name: :letter_online_references_uniq_idx,
          unique: true,
          comment: "A letter cannot have duplicate online references"
        )
      end
    end
  end
end
