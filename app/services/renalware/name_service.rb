# frozen_string_literal: true

# Map models to services and components. Works on class constants or instances.

module Renalware
  class NameService
    # We want to map to these base classes from their subclasses.
    # E.g. Letters::Letter::Completed maps to Letters::Letter...
    # And Events::Simple maps to Events::Event...
    # This list might not include all STI classes. Add them
    # here as needed.
    STI_CLASSES = [
      Renalware::Letters::Letter,
      Renalware::HD::Session,
      Renalware::Events::Event,
      Renalware::Clinics::ClinicVisit
    ].freeze

    # from: Fully qualified model class to map from or an instance
    #       (e.g. Messaging::Internal::Message)
    # to: class to map to (e.g. TimelineRow)
    # keep_class: Whether to keep the class name in the resulting fully qualifed name
    #             (e.g. true => RemoteMonitoring::Registration::Detail)
    #             (     false => RemoteMonitoring::Detail)
    # name_service_spec.rb has some good examples.
    def self.from_model(from, to:, keep_class: false)
      klass = STI_CLASSES.find { from.is_a?(it) } unless keep_class
      klass ||= from.is_a?(Class) ? from : from.class
      parts = klass.name.split("::")
      parts = keep_class ? (parts << to) : (parts[0..-2] << to)
      parts.join("::").constantize
    end
  end
end
