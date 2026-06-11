class OptimiseOldAdtFeedMessageHousekeeping < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  INDEX_NAME = :index_feed_messages_on_old_adt_housekeeping_candidates

  def up
    within_renalware_schema do
      add_index(
        :feed_messages,
        [:sent_at, :id],
        name: INDEX_NAME,
        where: "message_type = 'ADT' AND sent_at IS NOT NULL",
        algorithm: :concurrently,
        if_not_exists: true
      )

      load_function("housekeep_old_adt_feed_messages_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("housekeep_old_adt_feed_messages_v01.sql")

      remove_index(
        :feed_messages,
        name: INDEX_NAME,
        algorithm: :concurrently,
        if_exists: true
      )
    end
  end
end
