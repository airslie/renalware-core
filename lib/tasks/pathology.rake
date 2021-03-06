require "benchmark"

namespace :pathology do
  namespace :test do
    desc "In development only, import a test HL7 message. Useful for testing listeners."
    task import_one: :environment do
      raise NotImplementedError unless Rails.env.development?

      # Load the example HL7 file.
      path = Renalware::Engine.root.join("app", "jobs", "hl7_message_example.yml")
      raw_message = File.read(path)

      # It has a struct header at the top so it can also be dumped into
      # the delayed_job queue, but we want to skip queuing so strip out that header and simulate
      # the message being passed directly to the FeedJob which will persist and process the message.
      raw_message = raw_message.gsub("--- !ruby/struct:FeedJob\n", "")

      # Replace the MSH date with now() to guarantee a unique message. not doing so results in
      # an index violation becuase we calc am MD5 hash of the message and this has to be unique -
      # this prevents us importing the same message twice.
      raw_message = raw_message.gsub("20091112164645", Time.zone.now.strftime("%Y%m%d%H%M%S"))

      # Load the message into a hash as delayed_Job would do and splat the hash keys as keyword args
      # into the FeedJob ctor.
      hash = YAML.safe_load(*raw_message).symbolize_keys
      Delayed::Job.enqueue FeedJob.new(hash[:raw_message])
    end

    desc "In development only, enqueue a test HL7 message"
    task enqueue_one: :environment do
      raise NotImplementedError unless Rails.env.development?

      # Load the example HL7 file.
      path = Renalware::Engine.root.join("app", "jobs", "hl7_message_example.txt")
      raw_message = File.read(path)

      # Make sure line endings are \r and not \n or as that is how the HL7 looks
      raw_message = raw_message.gsub /\n/, "\r"

      # Replace the MSH date with now() to guarantee a unique message. not doing so results in
      # an index violation becuase we calc am MD5 hash of the message and this has to be unique -
      # this prevents us importing the same message twice.
      raw_message = raw_message.gsub("20091112164645", Time.zone.now.strftime("%Y%m%d%H%M%S"))

      ActiveRecord::Base.connection.execute(
        "select renalware.new_hl7_message('#{raw_message}'::text);"
      )
    end
  end
end
