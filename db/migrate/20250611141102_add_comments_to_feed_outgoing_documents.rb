class AddCommentsToFeedOutgoingDocuments < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      add_column :feed_outgoing_documents, :comments, :text, null: true
    end
  end
end
