class AddReligionAndLanguageToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :religion_id, :integer
    add_column :patients, :language_id, :integer

    add_foreign_key :patients, :religions
    add_foreign_key :patients, :languages
  end
end
