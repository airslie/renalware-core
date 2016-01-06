require "document/embedded"

module Renalware
  module Transplants
    class DonorFollowupDocument < Document::Embedded
      attribute :lost_to_followup, Document::Enum, enums: %i(yes no)
      attribute :transferred_for_followup, Document::Enum, enums: %i(yes no)
      attribute :dead_on, Date

      validates :dead_on, timeliness: { type: :date, allow_blank: true }
    end
  end
end