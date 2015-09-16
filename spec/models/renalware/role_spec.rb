require 'rails_helper'

module Renalware
  describe Role, :type => :model do
    it { should have_and_belong_to_many :users }
  end
end