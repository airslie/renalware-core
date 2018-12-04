class AddSentToUKRDCAtToPatients < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :patients, :sent_to_ukrdc_at, :datetime, index: true, null: true
    end
  end
end
