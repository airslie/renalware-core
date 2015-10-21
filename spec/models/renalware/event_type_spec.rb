require 'rails_helper'

module Renalware
  describe EventType, :type => :model do
    it { should have_many :events }

    it { should validate_presence_of :name }
  end
end