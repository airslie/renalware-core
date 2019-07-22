class ChangeTypeOfPatientsUKRDCExternalId < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      reversible do |dir|
        dir.up do
          change_column :patients, :ukrdc_external_id, :text, null: true
        end
        dir.down do
          change_column :patients, :ukrdc_external_id, "uuid USING UUID(ukrdc_external_id)", null: true
        end
      end

      remove_index :patients, :ukrdc_external_id
      add_index :patients, :ukrdc_external_id, unique: true
    end
  end
end
