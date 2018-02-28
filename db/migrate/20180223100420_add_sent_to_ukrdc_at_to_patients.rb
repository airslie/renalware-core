class AddSentToUKRDCAtToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :sent_to_ukrdc_at, :datetime, index: true, null: true
  end
end
