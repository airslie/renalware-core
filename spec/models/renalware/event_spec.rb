require 'rails_helper'

module Renalware
  describe Event, :type => :model do

    it { should belong_to :patient }
    it { should belong_to :event_type }

    it { should validate_presence_of :patient }
    it { should validate_presence_of :event_type }
    it { should validate_presence_of :date_time }
    it { should validate_presence_of :description }
    it { should validate_presence_of :notes }
  end
end