class AddRowColourToObservationDescriptions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :pathology_observation_descriptions, :colour, :enum_colour_name
    end
  end
end
