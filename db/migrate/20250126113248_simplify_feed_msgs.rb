class SimplifyFeedMsgs < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      # New fn no longer does upserts but instead ingests whatever you through at it.
      # Decided that housekeeping the feed_msgs table should be done out-of-band rather than
      # via upsert, to keep things slightly simpler, and easier to debug incoming message history.
      # A background job should be responsible for housekeeping.
      reversible do |direction|
        direction.up do
          connection.execute("drop function if exists renalware.feed_msgs_upsert_from_mirth")
          load_function("feed_msgs_upsert_from_mirth_v02.sql")
        end
        direction.down do
          connection.execute("drop function if exists renalware.feed_msgs_upsert_from_mirth")
          load_function("feed_msgs_upsert_from_mirth_v01.sql")
        end
      end

      # Remove unique indexes on feed_msgs for orc_filler_order_number and message_control_id
      # as we no longer enforce uniqueness and do upserts based on these columns
      remove_index :feed_msgs, :orc_filler_order_number
      add_index :feed_msgs, :orc_filler_order_number, unique: false

      remove_index :feed_msgs, :message_control_id
      add_index :feed_msgs, :message_control_id, unique: false
    end
  end
end
