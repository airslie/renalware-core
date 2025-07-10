# frozen_string_literal: true

module Renalware
  class NameService
    STATE_CLASSES = [
      Renalware::Letters::Letter,
      Renalware::HD::Session
    ].freeze

    STI_CLASSES = [
      Renalware::Events::Event
    ].freeze

    def self.from_model(from, to:, keep_class: false)
      klass = STATE_CLASSES.find { from.is_a?(it) }
      klass ||= STI_CLASSES.find { from.is_a?(it) } unless keep_class
      klass ||= from.is_a?(Class) ? from : from.class
      parts = klass.name.split("::")
      parts = keep_class ? (parts << to) : (parts[0..-2] << to)
      parts.join("::").constantize
    end
  end
end
