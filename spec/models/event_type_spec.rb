require 'rails_helper'

describe EventType, :type => :model do
  it { should validate_presence_of :name }
end
