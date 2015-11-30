require 'rails_helper'

module Renalware::Events
  describe Event, :type => :model do

    it { should belong_to :patient }
    it { should belong_to :event_type }

    it { should validate_presence_of :patient }
    it { should validate_presence_of :date_time }
    it { should validate_presence_of :description }

    it { is_expected.to validate_timeliness_of(:date_time) }
  end
end
