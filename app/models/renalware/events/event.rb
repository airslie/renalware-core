require_dependency "renalware/events"

module Renalware
  module Events
    class Event < ApplicationRecord
      include Accountable
      include PatientScope

      # Virtual attribute helps us persist in the UI (across posts) whether or not the
      # event_type can be changed. If we target e.g.
      #   patient_new_specific_event(slug: 'something')
      # it can be assumed we are creating an event of a certain type (event_type.slug ==
      # 'something') and therefore changing that type in the new event form should be disallowed
      attr_accessor :disable_selection_of_event_type

      belongs_to :patient
      belongs_to :event_type, class_name: "Type"

      validates :patient, :date_time, presence: true
      validates :date_time, timeliness: { type: :datetime }

      # By default an event has no embedded document but a subclass may
      # implement one using has_document
      def document
        NullObject.instance
      end

      def to_partial_path
        self.class.name.demodulize.underscore
      end
    end
  end
end
