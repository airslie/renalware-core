module Renalware
  class Event < ActiveRecord::Base
    belongs_to :patient
    belongs_to :event_type

    validates :patient, :date_time, :description, presence: true
  end
end
