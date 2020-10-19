class DeprecateIssuedOnInLetters < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_column_null :letter_letters, :issued_on, true # allow nulls
      rename_column :letter_letters, :issued_on, :legacy_issued_on
    end
  end
end
