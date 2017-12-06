class AddLoincCodeToObservationDescriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :pathology_observation_descriptions, :loinc_code, :string, index: :unique
  end
end
