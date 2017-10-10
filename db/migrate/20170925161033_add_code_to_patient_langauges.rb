class AddCodeToPatientLangauges < ActiveRecord::Migration[5.1]
  def change
    add_column :patient_languages, :code, :string
    add_index :patient_languages, :code, unique: true
  end
end
