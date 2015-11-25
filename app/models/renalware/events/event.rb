require_dependency "renalware/events"

module Renalware
  module Events
    class Event < ActiveRecord::Base
      include PatientScope

      belongs_to :patient
      belongs_to :event_type, class_name: "Type"

      validates :patient, :date_time, :description, presence: true

      validates :date_time, timeliness: { type: :datetime }
    end
  end
end
