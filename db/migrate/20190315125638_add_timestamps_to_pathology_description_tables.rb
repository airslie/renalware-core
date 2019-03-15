class AddTimestampsToPathologyDescriptionTables < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :pathology_request_descriptions, :created_at, :datetime
      add_column :pathology_request_descriptions, :updated_at, :datetime
      add_column :pathology_observation_descriptions, :created_at, :datetime
      add_column :pathology_observation_descriptions, :updated_at, :datetime
    end
  end
end
