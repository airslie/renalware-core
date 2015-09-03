module Renalware
  class Event < ActiveRecord::Base
    belongs_to :patients
    belongs_to :event_type

    validates :event_type_id, :date_time,
        :description, :notes, :presence => true
  end
end