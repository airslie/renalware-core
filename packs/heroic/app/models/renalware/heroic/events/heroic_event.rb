# frozen_string_literal: true

module Renalware
  module Heroic
    module Events
      class HeroicEvent < Renalware::Events::Event
        include ::Document::Base

        class Document < Heroic::Document
          # noop
        end
        has_document

        def self.policy_class
          Renalware::Events::EventPolicy
        end
      end
    end
  end
end
