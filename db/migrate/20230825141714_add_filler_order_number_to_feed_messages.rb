class AddFillerOrderNumberToFeedMessages < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :feed_messages, :orc_filler_order_number, :string
    end
  end
end
