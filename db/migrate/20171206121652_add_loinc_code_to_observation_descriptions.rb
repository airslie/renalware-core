class AddLoincCodeToObservationDescriptions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :pathology_observation_descriptions, :loinc_code, :string, index: :unique
    end
  end
end
