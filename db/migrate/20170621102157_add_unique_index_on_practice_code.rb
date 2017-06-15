class AddUniqueIndexOnPracticeCode < ActiveRecord::Migration[5.0]
  def change
    remove_index :patient_practices, :code
    add_index :patient_practices, :code, unique: true
  end
end
