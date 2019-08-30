class AddStatusToLetterBatchItems < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :letter_batch_items,
        :status,
        :integer,
        default: 0,
        null: false,
        limit: 2 # smallint
      )
      add_index :letter_batch_items, [:batch_id, :status]
    end
  end
end
