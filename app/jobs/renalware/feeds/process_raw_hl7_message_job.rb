# frozen_string_literal: true

module Renalware
  module Feeds
    class ProcessRawHL7MessageJob < ApplicationJob
      self.log_arguments = false
      retry_on ActiveRecord::StatementInvalid, wait: 5.seconds, attempts: 2
      retry_on ActiveRecord::RecordNotUnique, wait: 5.seconds, attempts: 2

      def perform(message:)
        Renalware::Feeds.message_processor.call(message)
      end
    end
  end
end
