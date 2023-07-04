class AddFeedMesssageIdToPathologyObservationRequests < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_column(
        :pathology_observation_requests,
        :feed_message_id,
        :integer,
        comment: "Reference to the feed_message from which this observation_request was created. " \
                 "There is no constraint on this relationship as feed_messages can be housekept."
      )
      add_index :pathology_observation_requests, :feed_message_id, algorithm: :concurrently
    end
  end
end
