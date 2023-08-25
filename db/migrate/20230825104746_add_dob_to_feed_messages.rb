class AddDobToFeedMessages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      begin
        add_column :feed_messages, :dob, :date
      rescue ActiveRecord::StatementInvalid => e
        if e.cause&.class == PG::DuplicateColumn
          # We may have manually added this column in order to get ahead of the game in
          # retrospectively populating DOB in feed_messages pre-release, so handle that here.
          puts "!! Skipping creation of feed_messages.dob column as it already exists"
        else
          raise e
        end
      end
    end
  end
end
