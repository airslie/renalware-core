# frozen_string_literal: true

module Renalware
  module Feeds
    # Called at a regular interval to pick up records in the RawHL7Message table,
    # and process them into Feeds::Message
    #
    class ProcessRawHL7MessagesCron < ApplicationJob
      def perform
        RawHL7Message.all.find_each do |raw_message|
          ProcessRawHL7MessageJob.perform_later(message: raw_message.body.tr("\r", "\n"))
          raw_message.destroy
        end
      end
    end
  end
end
