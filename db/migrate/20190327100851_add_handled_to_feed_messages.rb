class AddHandledToFeedMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :feed_messages, :processed, :boolean, default: false
  end
end
