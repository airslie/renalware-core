class UpdateFeedMsgsUpsertFromMirthFn5 < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        # new fn will support upsert with on on conflict(feed_msg_id)
        reversible do |direction|
          direction.up do
            connection.execute("drop function if exists renalware.feed_msgs_upsert_from_mirth")
            load_function("feed_msgs_upsert_from_mirth_v01.sql")
          end
          direction.down do
            connection.execute("drop function if exists renalware.feed_msgs_upsert_from_mirth")
          end
        end
      end
    end
  end
end
