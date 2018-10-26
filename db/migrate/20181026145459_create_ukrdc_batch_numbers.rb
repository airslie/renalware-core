class CreateUKRDCBatchNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :ukrdc_batch_numbers do |t|
      # no other columns, we just use the id as the batch number when sending data to the UKRDC.
      t.timestamps null: false
    end
  end
end
