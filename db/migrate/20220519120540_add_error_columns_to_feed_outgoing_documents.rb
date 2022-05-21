class AddErrorColumnsToFeedOutgoingDocuments < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :feed_outgoing_documents, :error_code, :string
      add_column :feed_outgoing_documents, :errored_at, :datetime
      add_column :feed_outgoing_documents, :retried_at, :datetime
    end
  end
end
