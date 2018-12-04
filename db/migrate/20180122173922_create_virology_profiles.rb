class CreateVirologyProfiles < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    within_renalware_schema do
      create_table :virology_profiles do |t|
      end
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
