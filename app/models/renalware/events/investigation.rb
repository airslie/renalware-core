require_dependency "renalware/events"
require "document/base"
require "document/embedded"
require "document/enum"

module Renalware
  module Events
    class Investigation < Event
      include Document::Base

      class Document < Document::Embedded
        attribute :type, ::Document::Enum # See i18n for options
        attribute :result, String
        validates :type, presence: true
        validates :result, presence: true
      end
      has_document
    end
  end
end
