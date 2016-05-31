class AddReligionAndLanguageToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :religion_id, :integer
    add_column :patients, :language_id, :integer

    add_foreign_key :patients, :patient_religions, column: :religion_id
    add_foreign_key :patients, :patient_languages, column: :language_id
  end
end
