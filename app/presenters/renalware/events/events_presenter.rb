require_dependency "renalware/events"

module Renalware
  module Events
    class EventsPresenter < SimpleDelegator
      attr_reader :patient

      def initialize(patient, events)
        @patient = patient
        super(events)
      end

      def users_for_filtering
        User.where(id: ids_of_users_having_created_events_for_this_patient)
            .distinct
            .order(family_name: :asc)
      end

      def event_types_for_filtering
        Events::Type
          .where(id: all_event_type_ids_in_use_for_this_patient)
          .distinct
          .order(name: :asc)
      end

      private

      def ids_of_users_having_created_events_for_this_patient
        Event.for_patient(patient).pluck(:created_by_id)
      end

      def all_event_type_ids_in_use_for_this_patient
        Event.for_patient(patient).pluck(:event_type_id)
      end
    end
  end
end
