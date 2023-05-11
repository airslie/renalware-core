class AddLocalPatientColsToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      safety_assured do
        change_table :feed_messages do |t|
          # This is the first step in migrating the patient_identifiers jsonb column into
          # discrete local_patient_id* columns. Here we create the columns ready, and
          # rename the patient_identifier to nhs_number, which is what it is being used for.
          #
          # When it comes to migrating the data from patient_identifiers into local_patient_id*
          # its important to drop the indexes on these 5 columns before migrating, then reinstate
          # them concurrently.
          #
          # // drop the indexes
          # DROP INDEX index_feed_messages_on_local_patient_id;
          # DROP INDEX index_feed_messages_on_local_patient_id_2;
          # DROP INDEX index_feed_messages_on_local_patient_id_3;
          # DROP INDEX index_feed_messages_on_local_patient_id_4;
          # DROP INDEX index_feed_messages_on_local_patient_id_5;
          #
          # // now do the updates...
          #
          # // re-create the indexes
          # CREATE INDEX CONCURRENTLY index_feed_messages_on_local_patient_id ON renalware.feed_messages USING btree (local_patient_id);
          # CREATE INDEX CONCURRENTLY index_feed_messages_on_local_patient_id_2 ON renalware.feed_messages USING btree (local_patient_id_2);
          # CREATE INDEX CONCURRENTLY index_feed_messages_on_local_patient_id_3 ON renalware.feed_messages USING btree (local_patient_id_3);
          # CREATE INDEX CONCURRENTLY index_feed_messages_on_local_patient_id_4 ON renalware.feed_messages USING btree (local_patient_id_4);
          # CREATE INDEX CONCURRENTLY index_feed_messages_on_local_patient_id_5 ON renalware.feed_messages USING btree (local_patient_id_5);
          t.string :local_patient_id,   index: { algorithm: :concurrently }, null: true
          t.string :local_patient_id_2, index: { algorithm: :concurrently }, null: true
          t.string :local_patient_id_3, index: { algorithm: :concurrently }, null: true
          t.string :local_patient_id_4, index: { algorithm: :concurrently }, null: true
          t.string :local_patient_id_5, index: { algorithm: :concurrently }, null: true
        end

        rename_column :feed_messages, :patient_identifier, :nhs_number
      end
    end
  end
end
