# frozen_string_literal: true

module Renalware
  class Letters::TimelineItem < Patients::TimelineItem
    def type = "Letter (#{record.state})"

    def description
      record.topic&.text || record.description
    end

    def detail
      record.body
    end

    private

    def fetch
      Letters::Letter.joins(:topic, :author)
    end
  end
end
