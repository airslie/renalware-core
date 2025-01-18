class UpdateFeedSausagesUpsertFromMirthFn5 < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        # Make index unique
        remove_index :feed_sausage_queue, :feed_sausage_id
        add_index :feed_sausage_queue, :feed_sausage_id, unique: true

        # new fn will support upsert with on on conflict(feed_sausage_id)
        reversible do |direction|
          direction.up do
            connection.execute("drop function if exists renalware.feed_sausages_upsert_from_mirth")
            load_function("feed_sausages_upsert_from_mirth_v05.sql")
          end
          direction.down do
            connection.execute("drop function if exists renalware.feed_sausages_upsert_from_mirth")
            load_function("feed_sausages_upsert_from_mirth_v04.sql")
          end
        end
      end
    end
  end
end
