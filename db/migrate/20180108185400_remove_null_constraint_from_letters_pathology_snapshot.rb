class RemoveNullConstraintFromLettersPathologySnapshot < ActiveRecord::Migration[5.1]
  def change
    change_column_null :letter_letters, :pathology_snapshot, true
  end
end
