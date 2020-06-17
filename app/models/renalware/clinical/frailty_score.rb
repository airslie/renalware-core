# frozen_string_literal: true

require_dependency "renalware/events"
require_dependency "renalware/clinical"
require "document/base"
require "document/embedded"
require "document/enum"

module Renalware
  module Clinical
    class FrailtyScore < Events::Event
      include Document::Base

      class Document < Document::Embedded
        attribute :score, ::Document::Enum # See i18n for options
        validates :score, presence: true, numericality: true
      end
      has_document

      # def partial_for(partial_type)
      #   File.join("renalware/clinical/frailty_score", partial_type)
      # end
    end
  end
end
