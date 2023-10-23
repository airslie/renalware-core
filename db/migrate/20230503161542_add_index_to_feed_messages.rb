class AddIndexToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index(
        :feed_messages,
        [:message_type, :event_type],
        name: :index_feed_messages_on_message_type_event_type,
        algorithm: :concurrently
      )
    end
  end
end
