# To create outside of Rails, insert into the `delayed_jobs` table:
#
#     handler: {see example.yml}
#     run_at: {current_time}
#
# Note: raw_message for the handler must have line endings "\n"
# To run delayed_jobs see e.g.
# http://blog.andolasoft.com/2013/04/4-simple-steps-to-implement-delayed-job-in-rails.html
# in devel use rake jobs:work
#
PathologyFeedJob = Struct.new(:raw_message) do
  def perform
    Renalware::Feeds::MessageProcessor.new.call(raw_message)
  end
end
