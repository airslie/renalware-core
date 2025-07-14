# frozen_string_literal: true

# Map models to services and components

module Renalware
  class NameService
    # We want to map to these base classes from their subclasses.
    # E.g. Letters::Letter::Completed maps to Letters::Letter...
    # And Events::Simple maps to Events::Event...
    # This list might not yet include all STI classes. Add them
    # here as needed when move more to components.
    STI_CLASSES = [
      Renalware::Letters::Letter,
      Renalware::HD::Session,
      Renalware::Events::Event,
      Renalware::Clinics::ClinicVisit
    ].freeze

    def self.from_model(from, to:, keep_class: false)
      klass = STI_CLASSES.find { from.is_a?(it) } unless keep_class
      klass ||= from.is_a?(Class) ? from : from.class
      parts = klass.name.split("::")
      parts = keep_class ? (parts << to) : (parts[0..-2] << to)
      parts.join("::").constantize
    end
  end
end
