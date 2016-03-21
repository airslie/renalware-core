# To create outside of Rails, insert a row with values for the following columns
# into the `delayed_jobs` table:
#
#     handler: {see h7_message_example.yml}
#     run_at: {current_time}
#
# Notes:
#
# - the key `raw_message` for the `handler` column must have line endings "\n"
# - to run delayed_jobs see in development use rake jobs:work
#
FeedJob = Struct.new(:raw_message) do
  def perform
    Renalware::Feeds.message_processor.call(raw_message)
  end
end
