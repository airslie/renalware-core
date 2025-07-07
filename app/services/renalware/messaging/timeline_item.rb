# frozen_string_literal: true

module Renalware
  class Messaging::TimelineItem < Patients::TimelineItem
    def type = "Message"

    def description
      record.subject
    end

    def detail
      record.body
    end

    def created_by
      record.author.full_name
    end

    private

    def fetch
      Messaging::Message
    end
  end
end
