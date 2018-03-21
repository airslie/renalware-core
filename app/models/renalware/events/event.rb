# frozen_string_literal: true

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

      belongs_to :patient, touch: true
      belongs_to :event_type, class_name: "Type"

      validates :patient, presence: true
      validates :date_time, presence: true
      validates :event_type_id, presence: true
      validates :date_time, timeliness: { type: :datetime }

      scope :ordered, -> { order(date_time: :desc, updated_at: :desc) }

      # By default an event has no embedded document but a subclass may
      # implement one using has_document
      def document
        NullObject.instance
      end

      def to_s
        description
      end

      # As Events are a cross domain model, a subclass can choose to override to_partial_path etc
      # in order to use events from another namespace for instance.
      def to_partial_path
        partial_for "inputs"
      end
      alias :to_input_partial_path :to_partial_path

      def to_cell_partial_path
        partial_for "cell"
      end

      def to_toggled_cell_partial_path
        partial_for "toggled_cell"
      end

      def partial_for(partial_type)
        File.join(
          "renalware/events/events",
          partial_type,
          self.class.name.demodulize.underscore
        )
      end

      private

      def our_class_name
        self.class.name.demodulize.underscore
      end
    end
  end
end
