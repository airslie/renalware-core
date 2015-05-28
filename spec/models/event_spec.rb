require 'rails_helper'

describe Event, :type => :model do
  it { should validate_presence_of :event_type_id }
  it { should validate_presence_of :date_time }
  it { should validate_presence_of :description }
  it { should validate_presence_of :notes }
end
