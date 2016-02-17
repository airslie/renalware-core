require "document/embedded"
require "document/enum"

module Renalware
  module Accesses
    class AssessmentDocument < Document::Embedded
      class Test < Document::Embedded
        attribute :method, Document::Enum
        attribute :flow_feed_artery
        attribute :has_art_stenosis, Document::Enum, enums: %i(yes no)
        attribute :art_stenosis_notes
        attribute :has_ven_stenosis, Document::Enum, enums: %i(yes no)
        attribute :ven_stenosis_notes
        attribute :has_residual_stenosis, Document::Enum, enums: %i(yes no)
      end
      attribute :test, Test

      class Admin < Document::Embedded
        attribute :next_surveillance_due, Document::Enum
        attribute :rx_decision
      end
      attribute :admin, Admin
    end
  end
end
